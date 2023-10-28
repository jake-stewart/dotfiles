let b:editObject = v:null

setlocal nonumber
" setlocal foldcolumn=1
setlocal nocursorline

augroup CustomMarkdown
  au!
  au BufWinEnter *.md call OnWinEnter()
  au BufEnter *.tbl,*.gez call OnObjectSourceEnter()
augroup END

let b:linkRegex = '^\s*\[[^\[\]]*\]([a-zA-Z0-9._\/ -]\+)$'
let b:imageRegex = '^\s*!\[[^\[\]]*\]([a-zA-Z0-9._\/ -]\+)$'

nnoremap <silent><buffer><backspace> :call BackLink()<CR>
nnoremap <silent><buffer><enter> :call OpenLink(line('.'))<CR>
nnoremap <silent><buffer><tab> :call JumpNextLink()<CR>
nnoremap <silent><buffer><s-tab> :call JumpPrevLink()<CR>

nnoremap <silent><buffer><leader>tt :call g:Table.new().create(input("Table Name: "))<CR>
nnoremap <silent><buffer><leader>tp :call g:Page.new().create(input("Page Name: "))<CR>
nnoremap <silent><buffer><leader>tg :call g:Graph.new().create(input("Graph Name: "))<CR>
nnoremap <silent><buffer><leader>ti :call g:Image.new().create(input("Image Name: "), input("Image Path: "))<CR>
nnoremap <silent><buffer><leader>tr :call RenameObject(line('.'))<CR>
nnoremap <silent><buffer><leader>td :call DeleteObject(line('.'))<CR>
nnoremap <silent><buffer><leader>tm :call MoveObject(line('.'))<CR>

if exists("g:md_functions_defined")
    finish
endif

let g:md_functions_defined = 1

let g:Page = {}

function g:Page.new()
    let l:newPage = copy(self)
    return l:newPage
endfunction

function g:Page.edit()
    silent! write
    exe 'edit ' . self.path . '/index.md'
endfunction

function g:Page.parse(line)
    let l:lineContent = getline(a:line)
    if l:lineContent !~ b:linkRegex
        return v:false
    endif
    let l:directory = substitute(l:lineContent, '^\s*\[.*\]', "", "g")
    let l:directory = substitute(l:directory, '[()]', "", "g")
    let l:directory = substitute(l:directory, '\/index.md$', "", "")

    let l:name = substitute(l:lineContent, '(.*)', "", "g")
    let l:name = substitute(l:name, '\(\s*\[\|\]$\)', "", "g")

    if strlen(l:directory) == 0
        return v:false
    endif
    if l:directory[0] == "/"
        let l:parent = "/"
        let l:path = l:directory
    else
        let l:parent = expand("%:p:h") . '/'
        let l:path = l:parent . l:directory
    endif

    let self.line = a:line
    let self.name = l:name
    let self.path = l:path
    let self.parent = l:parent
    let self.fileName = l:directory
    return v:true
endfunction

function g:Page.formatName(name)
    let l:name = tolower(a:name)
    let l:name = substitute(l:name, "+", "p", "g")
    let l:name = substitute(l:name, "&", "and", "g")
    let l:name = substitute(l:name, '\s', "_", "g")
    let l:name = substitute(l:name, "[^a-zA-Z0-9_-]", "", "g")
    return l:name
endfunction

function g:Page.draw()
    call cursor(self.line, 1)
    exe "norm " . (self.line >= line('$') ? 'o' : 'O')
                \ . '[' . self.name . '](' . self.fileName
                \ . '/index.md)'
endfunction

function! g:Page.erase()
    call self.deleteBuffer()
    exe ':' . self.line . 'd'
endfunction

function! g:Page.deleteBuffer()
    let l:bufnr = bufnr(self.path)
    if bufnr != -1
        try
            exe 'bdelete ' . l:bufnr
        catch
        endtry
    endif
endfunction

function! g:Page.delete()
    call system('rm -rf "$HOME/.cache/notes-bin/' . self.fileName . '"')
    call system("mv '" . self.path . "' ~/.cache/notes-bin")
    call self.erase()
endfunction

function! g:Page.move(newParent)
    let l:newParent = tolower(a:newParent)
    let l:newParent = substitute(l:newParent, "[^a-zA-Z0-9_/.-]", "_", "g")
    if strlen(l:newParent) == 0
        return
    endif
    let l:newParent = expand("%:p:h") . "/" . l:newParent
    let l:newPath = l:newParent . "/" . self.fileName
    if !isdirectory(l:newParent)
        redraw
        echo "Location is not a valid directory"
        return
    endif
    if filereadable(l:newPath) || isdirectory(l:newPath)
        redraw
        echo "Name already exists in destination"
        return
    endif
    call self.deleteBuffer()
    call self.erase()
    write
    call system("mv '" . self.path . "' '" . l:newPath . "'")
    let self.path = l:newPath
    let self.parent = l:newParent
    exe 'edit ' . self.parent . '/index.md'
    let self.line = line('$')
    silent call self.draw()
    write
endfunction

function! g:Page.rename(newName)
    let l:newName = self.formatName(a:newName)
    if strlen(l:newName) == 0
        return
    endif
    let l:newPath = expand("%:p:h") . "/" . l:newName
    if filereadable(l:newPath) || isdirectory(l:newPath)
        redraw
        echo "Name already taken"
        return v:false
    endif

    call system('mv "' . self.path . '" "' . l:newPath . '"')

    call self.erase()
    let self.path = l:newPath
    let self.name = a:newName
    let self.fileName = l:newName
    silent call self.draw()
    write
endfunction

function g:Page.create(name)
    let self.name = a:name
    let self.line = line('.')
    let self.fileName = self.formatName(a:name)
    if strlen(self.fileName) == 0
        return v:false
    endif
    let self.path = expand("%:p:h") . "/" . self.fileName
    if filereadable(self.path) || isdirectory(self.path)
        redraw
        echo "Page already exists"
        return v:false
    endif
    call system('mkdir -p "' . self.path . '"')
    silent call self.draw()
    write
    exe 'edit ' . self.path . "/index.md"
    exe 'norm i' . self.name
    exe 'norm o' . repeat("=", strlen(self.name))
    exe 'norm o'
    write
endfunction

let g:Image = {}

function g:Image.new()
    let l:newImage = copy(self)
    return l:newImage
endfunction

function g:Image.edit()
    " absolute monstrosity
    " i need to write directory to vim's controlling tty
    " this is because the script create an image via kitty graphics protocol
    " we write to kitty by writing to the controlling terminal
    " since i use tmux, we need to do a tmux passthrough
    " this does not work on the tmux popup since it only bypasses
    " to the controlling tmux tty
    exe 'lua io.open("/dev/stdout", "w")'
                \ . 'io.write(vim.fn.system({vim.fn.expand('
                \ . '"~/.config/tmux/popup-image.py"), "popup", [['
                \ . self.path . ']]}))'
endfunction

function g:Image.parse(line)
    let l:lineContent = getline(a:line)
    if l:lineContent !~ b:imageRegex
        return v:false
    endif
    " ![Tux, the Linux mascot](/assets/images/tux.png)
    let l:file = substitute(l:lineContent, '^\s*!\[.*\]', "", "g")
    let l:file = substitute(l:file, '[()]', "", "g")
    let l:file = substitute(l:file, '\/index.md$', "", "")

    let l:name = substitute(l:lineContent, '(.*)', "", "g")
    let l:name = substitute(l:name, '\(\s*!\[\|\]$\)', "", "g")

    if strlen(l:file) == 0
        return v:false
    endif
    let l:parent = expand("%:p:h") . '/'
    let l:path = l:parent . l:file

    let self.line = a:line
    let self.name = l:name
    let self.path = l:path
    let self.fileName = l:file
    return v:true
endfunction

function g:Image.formatName(name)
    let l:name = tolower(a:name)
    let l:name = substitute(l:name, "+", "p", "g")
    let l:name = substitute(l:name, "&", "and", "g")
    let l:name = substitute(l:name, '\s', "_", "g")
    let l:name = substitute(l:name, "[^a-zA-Z0-9_-]", "", "g")
    return l:name
endfunction

function g:Image.draw()
    call cursor(self.line, 1)
    exe "norm " . (self.line < line('$') ? 'o' : 'O')
                \ . '![' . self.name . '](' . self.fileName . ')'
endfunction

function! g:Image.erase()
    call self.deleteBuffer()
    exe ':' . self.line . 'd'
endfunction

function! g:Image.deleteBuffer()
    let l:bufnr = bufnr(self.path)
    if bufnr != -1
        try
            exe 'bdelete ' . l:bufnr
        catch
        endtry
    endif
endfunction

function! g:Image.delete()
    call system('rm -rf "$HOME/.cache/notes-bin/' . self.fileName . '"')
    call system("mv '" . self.path . "' ~/.cache/notes-bin")
    call self.erase()
endfunction

function! g:Image.move(newParent)
    let l:newParent = tolower(a:newParent)
    let l:newParent = substitute(l:newParent, "[^a-zA-Z0-9_/.-]", "_", "g")
    if strlen(l:newParent) == 0
        return
    endif
    let l:newParent = expand("%:p:h") . "/" . l:newParent
    let l:newPath = l:newParent . "/" . self.fileName
    if !isdirectory(l:newParent)
        redraw
        echo "Location is not a valid directory"
        return
    endif
    if filereadable(l:newPath) || isdirectory(l:newPath)
        redraw
        echo "Name already exists in destination"
        return
    endif
    call self.deleteBuffer()
    call self.erase()
    write
    call system("mv '" . self.path . "' '" . l:newPath . "'")
    let self.path = l:newPath
    let self.parent = l:newParent
    exe 'edit ' . self.parent . '/index.md'
    let self.line = line('$')
    silent call self.draw()
    write
endfunction

function! g:Image.rename(newName)
    let l:newName = self.formatName(a:newName)
    if strlen(l:newName) == 0
        return
    endif
    let l:newPath = expand("%:p:h") . "/" . l:newName
    if filereadable(l:newPath) || isdirectory(l:newPath)
        redraw
        echo "Name already taken"
        return v:false
    endif

    call system('mv "' . self.path . '" "' . l:newPath . '"')

    call self.erase()
    let self.path = l:newPath
    let self.name = a:newName
    let self.fileName = l:newName
    silent call self.draw()
    write
endfunction

function g:Image.create(name, path)
    let self.name = a:name
    let self.line = line('.')
    let self.fileName = self.formatName(a:name)
    if strlen(self.fileName) == 0
        return v:false
    endif
    let self.fileName = self.formatName(a:name) . ".png"
    let self.path = expand("%:p:h") . "/" . self.fileName
    if filereadable(self.path) || isdirectory(self.path)
        redraw
        echo "Image already exists"
        return v:false
    endif
    if !filereadable(a:path) || isdirectory(a:path)
        redraw
        echo "Source image does not exist"
        return v:false
    endif
    call system('cp "' . a:path . '" "' . self.path . '"')
    silent call self.draw()
    write
endfunction

let g:BlockObject = {}

function g:BlockObject.new()
    let l:newBlockObject = copy(self)
    return l:newBlockObject
endfunction

function g:BlockObject.edit()
    silent! write
    let b:editObject = self
    exe 'edit ' . self.path
    norm zz
endfunction

function g:BlockObject.erase()
    exe ':' . self.start . ',' . self.end . 'd'
endfunction

function g:BlockObject.draw()
    call cursor(self.start, 1)
    exe "norm " . (self.start >= line('$') ? 'o' : 'O')
    exe self.start . "!echo -e '```" . self.fileName . '\n\n```' . "'"
    exe (self.start + 1) . "!" . self.command(expand("%:p:h") . '/' . self.fileName)
    call cursor(self.start, 1)
endfunction

function g:BlockObject.formatName(name)
    let l:name = tolower(a:name)
    let l:name = substitute(l:name, "+", "p", "g")
    let l:name = substitute(l:name, "&", "and", "g")
    let l:name = substitute(l:name, '\s', "_", "g")
    let l:name = substitute(l:name, "[^a-zA-Z0-9_-]", "", "g")
    return l:name
endfunction

function g:BlockObject.create(name)
    let l:name = self.formatName(a:name)
    if strlen(l:name) == 0
        redraw
        echo "Invalid " .. tolower(self.objectType) .. " name"
        return v:false
    endif
    let self.fileName = l:name . "." . self.extension
    let self.path = expand("%:p:h") . "/" . self.fileName
    if filereadable(self.path)
        redraw
        echo self.objectType .. " already exists"
        return v:false
    endif
    let self.start = line('.')
    let self.end = line('.')
    call system("touch '" . self.path . "'")
    silent call self.draw()
endfunction

function g:BlockObject.deleteBuffer()
    let l:bufnr = bufnr(self.fileName)
    if bufnr != -1
        try
            exe 'bdelete ' . l:bufnr
        catch
        endtry
    endif
endfunction

function g:BlockObject.delete()
    call self.erase()
    call self.deleteBuffer()
    call system('rm -rf "$HOME/.cache/notes-bin/' . self.fileName . '"')
    call system("mv '" . self.path . "' ~/.cache/notes-bin")
endfunction

function! g:BlockObject.move(newParent)
    let l:newParent = tolower(a:newParent)
    let l:newParent = substitute(l:newParent, "[^a-zA-Z0-9_/.]", "_", "g")
    if strlen(l:newParent) == 0
        return
    endif
    let l:newParent = expand("%:p:h") . "/" . l:newParent
    let l:newPath = l:newParent . "/" . self.fileName
    if !isdirectory(l:newParent) || !filereadable(l:newParent . "/index.md")
        redraw
        echo "Location is not a valid directory"
        return
    endif
    if filereadable(l:newPath) || isdirectory(l:newPath)
        redraw
        echo "Name already exists in destination"
        return
    endif
    call self.deleteBuffer()
    call self.erase()
    write
    call system("mv '" . self.path . "' '" . l:newPath . "'")
    let self.path = l:newPath
    exe 'edit ' . l:newParent . '/index.md'
    let self.start = line('$')
    silent call self.draw()
    write
endfunction

function g:BlockObject.rename(newName)
    let l:newName = self.formatName(a:newName)
    if strlen(l:newName) == 0
        return v:false
    endif
    let l:newfileName = a:newName . "." . self.extension
    let l:newPath = expand("%:p:h") . "/" . l:newfileName
    if filereadable(l:newPath)
        redraw
        echo self.objectType .. " already exists"
        return v:false
    endif
    call system("mv '" . self.path . "' '" . l:newPath . "'")
    let self.path = l:newPath
    let self.fileName = l:newfileName
    call self.erase()
    silent call self.draw()
    call self.deleteBuffer()
    return v:true
endfunction

function g:BlockObject.parse(line)
    let l:line = a:line

    let l:end = -1
    let l:lineContent = getline(l:line)
    if l:lineContent =~ '^\s*```$'
        let l:end = l:line
        let l:line -= 1
    endif

    let l:regex = "^```[A-Za-z0-9_]*." . self.extension . "$"

    while l:line > 0
        let l:lineContent = getline(l:line)
        if l:lineContent =~ '^\s*```'
            if l:lineContent =~ l:regex
                let l:fileName = substitute(l:lineContent, "```", "", "")
                break
            endif
            return v:false
        endif
        let l:line -= 1
    endwhile

    if l:line == 0
        return v:false
    endif

    let l:start = l:line

    if l:end == -1
        let l:line += 1
        while l:line <= line('$')
            let l:lineContent = getline(l:line)
            if l:lineContent =~ '^\s*```$'
                break
            endif
            let l:line += 1
        endwhile

        if l:line == line('$') + 1
            return v:false
        endif
        let l:end = l:line
    endif

    let self.path = expand("%:p:h") . "/" . l:fileName
    let self.fileName = l:fileName
    let self.start = l:start
    let self.end = l:end
    return v:true
endfunction

let g:Table = copy(g:BlockObject)
let g:Table.objectType = "Table"
let g:Table.extension = "tbl"
function g:Table.command(filePath)
    return "tablescript '" . a:filePath . "'"
endfunction

let g:Graph = copy(g:BlockObject)
let g:Table.objectType = "Graph"
let g:Graph.extension = "gez"
function g:Graph.command(filePath)
    return "graph-easy --as boxart '" . a:filePath . "' | sed '/^$/d'"
endfunction

function! CreateGraph()
    let l:name = input("Graph Name: ")
    let l:graph = g:Graph.new()
    call l:graph.create(l:name)
endfunction

function! CreateTable()
    let l:name = input("Table Name: ")
    let l:table = g:Table.new()
    call l:table.create(l:name)
endfunction

function! CreatePage()
    let l:pageName = input("Page Name: ")
    let l:page = g:Page.new()
    call l:page.create(l:pageName)
endfunction

function! CreateImage()
    let l:imageName = input("Image Name: ")
    let l:imagePath = input("Image Path: ")
    let l:image = g:Image.new()
    call l:image.create(l:imageName, l:imagePath)
endfunction

function! JumpNextLink()
    call search(b:linkRegex)
endfunction

function! JumpPrevLink()
    call search(b:linkRegex, "b")
endfunction

function! BackLink()
    if expand("%:t") == "index.md"
        let l:parent = expand("%:p:h:h")
        let l:fileName = l:parent . "/" . "index.md"
        if !filereadable(l:fileName)
            return
        endif
    else
        let l:parent = expand("%:p:h")
        let l:fileName = l:parent . "/" . "index.md"
        if !filereadable(l:fileName)
            return
        endif
    endif
    update
    exe "edit " . l:fileName
endfunction

function! ParseCursorObject()
    let l:object = g:Image.new()
    if l:object.parse(line('.'))
        return l:object
    endif
    let l:object = g:Page.new()
    if l:object.parse(line('.'))
        return l:object
    endif
    let l:object = g:Table.new()
    if l:object.parse(line('.'))
        return l:object
    endif
    let l:object = g:Graph.new()
    if l:object.parse(line('.'))
        return l:object
    endif
    return v:null
endfunction

function! MoveObject(line)
    let l:object = ParseCursorObject()
    if type(l:object) == v:null
        echo "Not an object"
        return
    endif
    call l:object.move(input("New Location: "))
    return
endfunction

function! RenameObject(line)
    let l:object = ParseCursorObject()
    if type(l:object) == v:null
        echo "Not an object"
        return
    endif
    call l:object.rename(input("New Name: "))
endfunction

function! DeleteObject(line)
    let l:object = ParseCursorObject()
    if type(l:object) == v:null
        echo "Not an object"
        return
    endif
    call l:object.delete()
endfunction

function! OpenLink(line)
    let l:object = ParseCursorObject()
    if type(l:object) == type(v:null)
        echo "Not an object"
        return
    endif
    call l:object.edit()
endfunction

function! OnWinEnter()
    if type(b:editObject) != v:t_dict
        return
    endif
    call b:editObject.erase()
    silent call b:editObject.draw()
    write
    normal! zz
    let b:editObject = v:null
endfunction

function! ObjectSourceBacklink()
    write
    exe "norm \<c-6>"
endfunction

function! OnObjectSourceEnter()
    nnoremap <silent><buffer><backspace> :call ObjectSourceBacklink()<CR>
endfunction

hi link CodeBlock CursorLine

lua << EOF

function table.find(l, f)
  for i, v in ipairs(l) do
    if f(v) then
      return i, v
    end
  end
  return nil, nil
end

local cb_nsid = vim.api.nvim_create_namespace("md")

local codeStartRegex = vim.regex([[^\s*```.*$]])
local codeEndRegex = vim.regex([[^.*```.*$]])

local extMarkId = 0

local cbMarks = {}

local function deleteMark(id)
    return vim.api.nvim_buf_del_extmark(0, cb_nsid, id)
end

local function getMark(id, opts)
    return vim.api.nvim_buf_get_extmark_by_id(0, cb_nsid, id, opts or {})
end

local function setMark(line, opts)
    return vim.api.nvim_buf_set_extmark(0, cb_nsid, line, 0, opts or {})
end

local function getMarks(start, _end, opts)
    return vim.api.nvim_buf_get_extmarks(
        0,
        cb_nsid,
        {start, 0},
        {_end, 0},
        opts or {}
    )
end

function parseMark(line, idx)
    local eof = vim.fn.line("$")
    local line_text = vim.fn.getline(line)
    local startLine = line
    local title = string.sub(line_text, 4, #line_text)
    line = line + 1
    local matched = false
    while line <= eof do
        if codeEndRegex:match_str(vim.fn.getline(line)) then
            matched = true
            break
        end
        line = line + 1
    end

    if not matched then
        return line
    end

    extMarkId = extMarkId + 1
    local start_mark_id = setMark(startLine - 1, {
        id = extMarkId,
        end_row = line,
        -- virt_text = {{extMarkId .. " " .. title, "CodeBlock"}},
        virt_text = {{title, "CodeBlock"}},
        virt_text_pos = 'right_align',
        line_hl_group = "CodeBlock",
        hl_group = "CodeBlock",
        hl_eol = true,
    })

    extMarkId = extMarkId + 1
    local end_mark_id = setMark(line - 1, {
        id = extMarkId,
        line_hl_group = "CodeBlock",
        hl_group = "CodeBlock",
        hl_eol = true,
    })

    if idx == nil then
        table.insert(cbMarks, {start_mark_id, end_mark_id})
    else
        cbMarks[idx] = {start_mark_id, end_mark_id}
    end
    return line
end

function generateExtMarks(line, endLine, idx)
    while line <= endLine do
        if codeStartRegex:match_str(vim.fn.getline(line)) then
            line = parseMark(line, idx)
            if idx ~= nil then
                idx = idx + 1
            end
        end
        line = line + 1
    end
end

function max(a, b)
    if a == nil or b == nil then return a or b end
    if a > b then return a else return b end
end

function min(a, b)
    if a == nil or b == nil then return a or b end
    if a < b then return a else return b end
end

function checkLine(start, _end)
    local dirtyIdx = nil
    local dirtyEndIdx = nil
    local dirtyLine = nil

    local marks = getMarks(max(1, start - 1), _end - 1)
    for _, mark in pairs(marks) do
        local idx, _ = table.find(cbMarks, function(cbMark)
            return cbMark[1] == mark[1] or cbMark[2] == mark[1]
        end)
        local cbMark = cbMarks[idx]
        local cbStart = getMark(cbMark[1])
        local cbEnd = getMark(cbMark[2])
        local cbStartValid = codeStartRegex:match_str(
            vim.fn.getline(cbStart[1] + 1))
        local cbEndValid = codeEndRegex:match_str(
            vim.fn.getline(cbEnd[1] + 1))
        if cbStart[1] ~= cbEnd[1] and cbStartValid and cbEndValid then
            -- print('dirty because on valid boundary')
            dirtyIdx = min(dirtyIdx, idx)
            dirtyEndIdx = max(dirtyEndIdx, idx)
        else
            -- print('dirty because on invalid boundary')
            dirtyIdx = min(dirtyIdx, idx)
            dirtyEndIdx = #cbMarks
        end
    end

    for line = max(1, start), _end do
        if codeEndRegex:match_str(vim.fn.getline(line)) then
            if #getMarks(line - 1, line - 1, {limit = 1}) == 0 then
                local marks = getMarks(line - 2, 0, {limit = 1})
                if #marks ~= 0 then
                    -- print('dirty because found find boundary')
                    local mark = marks[1]
                    local idx, _ = table.find(cbMarks, function(cbMark)
                        return cbMark[1] == mark[1] or cbMark[2] == mark[1]
                    end)
                    dirtyIdx = min(dirtyIdx, idx)
                    dirtyEndIdx = #cbMarks
                else
                    -- print('dirty because cannot find boundary')
                    dirtyIdx = 1
                    dirtyEndIdx = #cbMarks
                    dirtyLine = line
                    break
                end
            end
        end
    end

    if dirtyIdx and dirtyEndIdx then
        local startLine = dirtyLine or getMark(cbMarks[dirtyIdx][1])[1] + 1
        if dirtyEndIdx == #cbMarks then
            for i = dirtyIdx, dirtyEndIdx do
                local cbMark = table.remove(cbMarks, dirtyIdx)
                deleteMark(cbMark[1])
                deleteMark(cbMark[2])
            end
            generateExtMarks(startLine, vim.fn.line("$"))
        else
            local endLine = getMark(cbMarks[dirtyEndIdx][2])[1]
            for i = dirtyIdx, dirtyEndIdx do
                local cbMark = cbMarks[i]
                deleteMark(cbMark[1])
                deleteMark(cbMark[2])
            end
            generateExtMarks(startLine, endLine, dirtyIdx)
        end
    end
end

generateExtMarks(1, vim.fn.line("$"))

vim.api.nvim_create_augroup("CodeBlocks", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.md",
    group = "CodeBlocks",
    callback = function() generateExtMarks(1, vim.fn.line("$")) end
})

local insertStartLookup = {}

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*.md",
    group = "CodeBlocks",
    callback = function()
        insertStartLookup[vim.fn.winnr()] = vim.fn.line('.')
    end
})

vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*.md",
    group = "CodeBlocks",
    callback = function()
        local winnr = vim.fn.winnr()
        local start = insertStartLookup[winnr]
        local _end = vim.fn.line('.')
        insertStartLookup[winnr] = _end
        checkLine(min(start, _end), max(start, _end))
    end
})

vim.api.nvim_create_autocmd("TextChanged", {
    group = "CodeBlocks",
    pattern = "*.md",
    callback = function()
        local start = vim.fn.getpos("'[")[2]
        local _end = vim.fn.getpos("']")[2]
        checkLine(min(start, _end), max(start, _end))
    end
})








-------------------------------------------------------
local glyphs = {
    "\u{0305}", "\u{030D}", "\u{030E}", "\u{0310}", "\u{0312}", "\u{033D}", "\u{033E}", "\u{033F}",
    "\u{0346}", "\u{034A}", "\u{034B}", "\u{034C}", "\u{0350}", "\u{0351}", "\u{0352}", "\u{0357}",
    "\u{035B}", "\u{0363}", "\u{0364}", "\u{0365}", "\u{0366}", "\u{0367}", "\u{0368}", "\u{0369}",
    "\u{036A}", "\u{036B}", "\u{036C}", "\u{036D}", "\u{036E}", "\u{036F}", "\u{0483}", "\u{0484}",
    "\u{0485}", "\u{0486}", "\u{0487}", "\u{0592}", "\u{0593}", "\u{0594}", "\u{0595}", "\u{0597}",
    "\u{0598}", "\u{0599}", "\u{059C}", "\u{059D}", "\u{059E}", "\u{059F}", "\u{05A0}", "\u{05A1}",
    "\u{05A8}", "\u{05A9}", "\u{05AB}", "\u{05AC}", "\u{05AF}", "\u{05C4}", "\u{0610}", "\u{0611}",
    "\u{0612}", "\u{0613}", "\u{0614}", "\u{0615}", "\u{0616}", "\u{0617}", "\u{0657}", "\u{0658}",
    "\u{0659}", "\u{065A}", "\u{065B}", "\u{065D}", "\u{065E}", "\u{06D6}", "\u{06D7}", "\u{06D8}",
    "\u{06D9}", "\u{06DA}", "\u{06DB}", "\u{06DC}", "\u{06DF}", "\u{06E0}", "\u{06E1}", "\u{06E2}",
    "\u{06E4}", "\u{06E7}", "\u{06E8}", "\u{06EB}", "\u{06EC}", "\u{0730}", "\u{0732}", "\u{0733}",
    "\u{0735}", "\u{0736}", "\u{073A}", "\u{073D}", "\u{073F}", "\u{0740}", "\u{0741}", "\u{0743}",
    "\u{0745}", "\u{0747}", "\u{0749}", "\u{074A}", "\u{07EB}", "\u{07EC}", "\u{07ED}", "\u{07EE}",
    "\u{07EF}", "\u{07F0}", "\u{07F1}", "\u{07F3}", "\u{0816}", "\u{0817}", "\u{0818}", "\u{0819}",
    "\u{081B}", "\u{081C}", "\u{081D}", "\u{081E}", "\u{081F}", "\u{0820}", "\u{0821}", "\u{0822}",
    "\u{0823}", "\u{0825}", "\u{0826}", "\u{0827}", "\u{0829}", "\u{082A}", "\u{082B}", "\u{082C}",
    "\u{082D}", "\u{0951}", "\u{0953}", "\u{0954}", "\u{0F82}", "\u{0F83}", "\u{0F86}", "\u{0F87}",
    "\u{135D}", "\u{135E}", "\u{135F}", "\u{17DD}", "\u{193A}", "\u{1A17}", "\u{1A75}", "\u{1A76}",
    "\u{1A77}", "\u{1A78}", "\u{1A79}", "\u{1A7A}", "\u{1A7B}", "\u{1A7C}", "\u{1B6B}", "\u{1B6D}",
    "\u{1B6E}", "\u{1B6F}", "\u{1B70}", "\u{1B71}", "\u{1B72}", "\u{1B73}", "\u{1CD0}", "\u{1CD1}",
    "\u{1CD2}", "\u{1CDA}", "\u{1CDB}", "\u{1CE0}", "\u{1DC0}", "\u{1DC1}", "\u{1DC3}", "\u{1DC4}",
    "\u{1DC5}", "\u{1DC6}", "\u{1DC7}", "\u{1DC8}", "\u{1DC9}", "\u{1DCB}", "\u{1DCC}", "\u{1DD1}",
    "\u{1DD2}", "\u{1DD3}", "\u{1DD4}", "\u{1DD5}", "\u{1DD6}", "\u{1DD7}", "\u{1DD8}", "\u{1DD9}",
    "\u{1DDA}", "\u{1DDB}", "\u{1DDC}", "\u{1DDD}", "\u{1DDE}", "\u{1DDF}", "\u{1DE0}", "\u{1DE1}",
    "\u{1DE2}", "\u{1DE3}", "\u{1DE4}", "\u{1DE5}", "\u{1DE6}", "\u{1DFE}", "\u{20D0}", "\u{20D1}",
    "\u{20D4}", "\u{20D5}", "\u{20D6}", "\u{20D7}", "\u{20DB}", "\u{20DC}", "\u{20E1}", "\u{20E7}",
    "\u{20E9}", "\u{20F0}", "\u{2CEF}", "\u{2CF0}", "\u{2CF1}", "\u{2DE0}", "\u{2DE1}", "\u{2DE2}",
    "\u{2DE3}", "\u{2DE4}", "\u{2DE5}", "\u{2DE6}", "\u{2DE7}", "\u{2DE8}", "\u{2DE9}", "\u{2DEA}",
    "\u{2DEB}", "\u{2DEC}", "\u{2DED}", "\u{2DEE}", "\u{2DEF}", "\u{2DF0}", "\u{2DF1}", "\u{2DF2}",
    "\u{2DF3}", "\u{2DF4}", "\u{2DF5}", "\u{2DF6}", "\u{2DF7}", "\u{2DF8}", "\u{2DF9}", "\u{2DFA}",
    "\u{2DFB}", "\u{2DFC}", "\u{2DFD}", "\u{2DFE}", "\u{2DFF}", "\u{A66F}", "\u{A67C}", "\u{A67D}",
    "\u{A6F0}", "\u{A6F1}", "\u{A8E0}", "\u{A8E1}", "\u{A8E2}", "\u{A8E3}", "\u{A8E4}", "\u{A8E5}",
    "\u{A8E6}", "\u{A8E7}", "\u{A8E8}", "\u{A8E9}", "\u{A8EA}", "\u{A8EB}", "\u{A8EC}", "\u{A8ED}",
    "\u{A8EE}", "\u{A8EF}", "\u{A8F0}", "\u{A8F1}", "\u{AAB0}", "\u{AAB2}", "\u{AAB3}", "\u{AAB7}",
    "\u{AAB8}", "\u{AABE}", "\u{AABF}", "\u{AAC1}", "\u{FE20}", "\u{FE21}", "\u{FE22}", "\u{FE23}",
    "\u{FE24}", "\u{FE25}", "\u{FE26}",
    "\u{00010A0F}", "\u{00010A38}", "\u{0001D185}", "\u{0001D186}", "\u{0001D187}",
    "\u{0001D188}", "\u{0001D189}", "\u{0001D1AA}", "\u{0001D1AB}", "\u{0001D1AC}",
    "\u{0001D1AD}", "\u{0001D242}", "\u{0001D243}", "\u{0001D244}"
}


local function enableTmuxPassthrough()
    vim.fn.system("tmux set -p allow-passthrough on")
end

local function kittyGraphicsDelete(id)
    return "\x1b_Ga=d,q=2,d=I,i=" .. id .. "\x1b\\"
end

local function kittyGraphics(filename, kwargs)
    local buffer = {"\x1b_G"}
    local optsBuffer = {}
    for k, v in pairs(kwargs) do
        table.insert(optsBuffer, k .. "=" .. v)
    end
    table.insert(buffer, vim.fn.join(optsBuffer, ","))
    table.insert(buffer, ";")
    table.insert(buffer, vim.fn.system({"base64"}, filename))
    table.insert(buffer, "\x1b\\")
    return vim.fn.join(buffer, "")
end

local function tmuxPassthrough(string)
    string = vim.fn.substitute(string, "\x1b", "\x1b\x1b", "g")
    return "\x1bPtmux;" .. string .. "\x1b\\"
end

local function prepare(id, filename, cols, rows)
    local width = cols
    local height = rows

    enableTmuxPassthrough()
    local deleteCmd = kittyGraphicsDelete(id)
    local cmd = kittyGraphics(filename, {
        f=100, q=2, U=1, X=0, i=id, a="T", c=width, r=height, t="f"
    })

    local stdout = io.open("/dev/stdout", "w")
    if (stdout) then
        stdout:write(tmuxPassthrough(deleteCmd))
        stdout:flush()
        stdout:write(tmuxPassthrough(cmd))
        stdout:flush()
    end
end

local function createLines(cols, rows)
    local lines = {}
    for row = 1, rows do
        local buffer = {}
        for col = 1, cols do
            table.insert(buffer, "\u{0010EEEE}")
            table.insert(buffer, glyphs[row])
            table.insert(buffer, glyphs[col])
        end
        table.insert(lines, vim.fn.join(buffer, ""))
    end
    return lines
end

local rows = 10

--
-- lines = vim.fn.map(createLines(cols, rows), function(i, line)
--     return {{line, "Image70"}}
-- end)
--
-- -- vim.print(lines)
-- setMark(1, {
--     virt_lines = lines
-- })

local img_nsid = vim.api.nvim_create_namespace("md_images")

-- [id, path][]
local imgMarks = {}

-- [path, id, cols, listeners][]
local images = {}

local imgRegex = vim.regex("^\\s*!\\[[^\\[\\]]*\\]([a-zA-Z0-9._\\/ -]\\+)$")
local imgPathRegex = vim.regex("(\\zs[a-zA-Z0-9._\\/ -]\\+\\ze)$")

function generateImgMark(line, idx)
    local str = vim.fn.getline(line)
    start, _end = imgPathRegex:match_str(str)
    if start == nil then
        if idx ~= nil then
            vim.api.nvim_buf_del_extmark(0, img_nsid, imgMarks[idx][1])
            table.remove(imgMarks, idx)
        end
        return
    end

    local path = vim.fn.expand("%:p:h") .. "/" .. string.sub(str, start + 1, _end)
    local imageIdx = table.find(images, function (image) return image[1] == path end)

    if imageIdx == nil then
        local id = 1
        while true do
            local match = table.find(images, function(image)
                return image[2] == id
            end)
            if match == nil then
                break
            end
            id = id + 1
        end
        if id >= 256 then
            return
        end
        local info = vim.fn.system({"identify", path})
        if vim.v.shell_error ~= 0 then
            return
        end
        local dimensions = vim.fn.split(info, " ")[3]
        local w, h = unpack(vim.fn.split(dimensions, "x"))
        local ratio = tonumber(w) / tonumber(h)
        local cols = math.floor(ratio * rows * 2.5)
        prepare(id, path, cols, rows)
        table.insert(images, {path, id, cols, 1})
        imageIdx = #images

        local idHex = string.format("%x", id)
        if #idHex == 1 then idHex = "0" .. idHex end
        vim.cmd.hi("Image" .. id, "ctermfg=" .. id, "guifg=#0000" .. idHex)
    end

    local image = images[imageIdx]

    local lines = vim.fn.map(createLines(image[3], rows), function(i, line)
        return {{line, "Image" .. image[2]}}
    end)

    local id = vim.api.nvim_buf_set_extmark(0, img_nsid, line - 1, 0, {
        virt_lines = lines
    })
    table.insert(imgMarks, {id, path})
end

function generateImgExtMarks(line, endLine)
    while line <= endLine do
        if imgRegex:match_str(vim.fn.getline(line)) then
            generateImgMark(line)
        end
        line = line + 1
    end
end

function checkLineImg(start, _end)
    local marks = vim.api.nvim_buf_get_extmarks(
        0,
        img_nsid,
        {max(1, start - 1), 0},
        {_end - 1, 0},
        opts or {}
    )
    for _, mark in pairs(marks) do
        local idx, _ = table.find(imgMarks, function(imgMark)
            return imgMark[1] == mark[1]
        end)
        generateImgMark(mark[2], idx)
    end

    for line = max(1, start), _end do
        if imgRegex:match_str(vim.fn.getline(line)) then
            local marks = vim.api.nvim_buf_get_extmarks(
                0,
                img_nsid,
                {line - 1, 0},
                {line - 1, 0},
                {limit = 1}
            )
            if #marks == 0 then
                generateImgMark(line)
            end
        end
    end
end

generateImgExtMarks(1, vim.fn.line("$"))


vim.api.nvim_create_augroup("MarkdownImages", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.md",
    group = "MarkdownImages",
    callback = function() generateImgExtMarks(1, vim.fn.line("$")) end
})

local imgsInsertStartLookup = {}

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*.md",
    group = "MarkdownImages",
    callback = function()
        imgsInsertStartLookup[vim.fn.winnr()] = vim.fn.line('.')
    end
})

vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*.md",
    group = "MarkdownImages",
    callback = function()
        local winnr = vim.fn.winnr()
        local start = imgsInsertStartLookup[winnr]
        local _end = vim.fn.line('.')
        imgsInsertStartLookup[winnr] = _end
        checkLineImg(min(start, _end), max(start, _end))
    end
})

vim.api.nvim_create_autocmd("TextChanged", {
    group = "MarkdownImages",
    pattern = "*.md",
    callback = function()
        local start = vim.fn.getpos("'[")[2]
        local _end = vim.fn.getpos("']")[2]
        checkLineImg(min(start, _end), max(start, _end))
    end
})

EOF


