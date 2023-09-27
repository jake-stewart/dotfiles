let b:editObject = v:null

setlocal nonumber
setlocal foldcolumn=1
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
    exe "norm " . (self.line >= line('$') ? 'o' : 'O')
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

local ns_id = vim.api.nvim_create_namespace("md")

local codeStartRegex = vim.regex([[^\s*```.*$]])
local codeEndRegex = vim.regex([[^.*```.*$]])

local extMarkId = 0

local cbMarks = {}

local function deleteMark(id)
    return vim.api.nvim_buf_del_extmark(0, ns_id, id)
end

local function getMark(id, opts)
    return vim.api.nvim_buf_get_extmark_by_id(0, ns_id, id, opts or {})
end

local function setMark(line, opts)
    return vim.api.nvim_buf_set_extmark(0, ns_id, line, 0, opts or {})
end

local function getMarks(start, _end, opts)
    return vim.api.nvim_buf_get_extmarks(
        0,
        ns_id,
        {start, 0},
        {_end, 0},
        opts or {}
    )
end

function parseMark(line, idx)
    local eof = vim.fn.line("$")
    local line_text = vim.fn.getline(line)
    local startLine = line
    local lang = string.sub(line_text, 4, #line_text)
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
        virt_text = {{lang, "CodeBlock"}},
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
        if cbStartValid and cbEndValid then
            dirtyIdx = min(dirtyIdx, idx)
            dirtyEndIdx = max(dirtyEndIdx, idx)
        else
            dirtyIdx = min(dirtyIdx, idx)
            dirtyEndIdx = #cbMarks
        end
    end

    for line = max(1, start), _end do
        if codeEndRegex:match_str(vim.fn.getline(line)) then
            if #getMarks(line - 1, line - 1, {limit = 1}) == 0 then
                local marks = getMarks(line - 2, 0, {limit = 1})
                if #marks ~= 0 then
                    local mark = marks[1]
                    local idx, _ = table.find(cbMarks, function(cbMark)
                        return cbMark[1] == mark[1] or cbMark[2] == mark[1]
                    end)
                    dirtyIdx = min(dirtyIdx, idx)
                    dirtyEndIdx = #cbMarks
                else
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

vim.api.nvim_create_augroup("CodeBlocks", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.md",
    group = "CodeBlocks",
    callback = function() generateExtMarks(1, vim.fn.line("$")) end
})

vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*",
    group = "CodeBlocks",
    callback = function()
        local start = vim.fn.getpos("'[")[2]
        local _end = vim.fn.line('.')
        checkLine(min(start, _end), max(start, _end))
    end
})

vim.api.nvim_create_autocmd("TextChanged", {
    pattern = "*",
    group = "CodeBlocks",
    callback = function()
        local start = vim.fn.getpos("'[")[2]
        local _end = vim.fn.getpos("']")[2]
        checkLine(min(start, _end), max(start, _end))
    end
})

EOF
