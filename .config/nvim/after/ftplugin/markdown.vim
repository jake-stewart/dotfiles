let b:editTable = v:null

augroup Tablescript
  au!
  au BufWinEnter *.md call OnWinEnter()
  au BufEnter *.tbl call OnTablescriptEnter()
augroup END

let b:linkRegex = '^\s*([a-zA-Z0-9.,_\/ -]*)\[[a-zA-Z0-9._\/ -]\+\]$'

nnoremap <silent><buffer><backspace> :call BackLink()<CR>
nnoremap <silent><buffer><enter> :call OpenLink(line('.'))<CR>
nnoremap <silent><buffer><tab> :call JumpNextLink()<CR>
nnoremap <silent><buffer><s-tab> :call JumpPrevLink()<CR>

nnoremap <silent><buffer><leader>tt :call CreateTable()<CR>
nnoremap <silent><buffer><leader>tp :call CreatePage()<CR>
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
    exe 'edit ' . self.path . '/index.md'
endfunction

function g:Page.parse(line)
    let l:lineContent = getline(a:line)
    if l:lineContent !~ '^([a-zA-Z0-9.,_\/ -]*)\[[a-zA-Z0-9._\/ -]\+\]$'
        return v:false
    endif
    let l:directory = substitute(l:lineContent, '^(.*)', "", "g")
    let l:directory = substitute(l:directory, '[\[\]]', "", "g")
    let l:directory = substitute(l:directory, "\/index.md$", "", "")

    let l:name = substitute(l:lineContent, '\[.*\]', "", "g")
    let l:name = substitute(l:name, '[()]', "", "g")

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
    let l:name = substitute(l:name, "[^a-zA-Z0-9_-]", "_", "g")
    return l:name
endfunction

function g:Page.draw()
    call cursor(self.line, 1)
    exe "norm " . (self.line >= line('$') ? 'o' : 'O')
                \ . '(' . self.name . ')[' . self.fileName
                \ . '/index.md]'
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
    call self.draw()
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
    call self.draw()
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
    call self.draw()
    write
    exe 'edit ' . self.path . "/index.md"
    exe 'norm i' . self.name
    exe 'norm o' . repeat("=", strlen(self.name))
    exe 'norm o'
    write
endfunction

let g:Table = {}

function g:Table.new()
    let l:newTable = copy(self)
    return l:newTable
endfunction

function g:Table.edit()
    let b:editTable = self
    exe 'edit ' . self.path
endfunction

function g:Table.erase()
    exe ':' . self.start . ',' . self.end . 'd'
endfunction

function g:Table.draw()
    call cursor(self.start, 1)
    exe "norm " . (self.start >= line('$') ? 'o' : 'O')
    exe self.start . "!echo -e '```" . self.fileName . '\n\n```' . "'"
    exe (self.start + 1) . '!tablescript ' . expand("%:p:h")
                \ . '/' . self.fileName
    call cursor(self.start, 1)
endfunction

function g:Table.formatName(name)
    let l:name = tolower(a:name)
    let l:name = substitute(l:name, "[^a-zA-Z0-9_]", "_", "g")
    return l:name
endfunction

function g:Table.create(name)
    let l:name = self.formatName(a:name)
    if strlen(l:name) == 0
        redraw
        echo "Invalid table name"
        return v:false
    endif
    let self.fileName = l:name . ".tbl"
    let self.path = expand("%:p:h") . "/" . self.fileName
    if filereadable(self.path)
        redraw
        echo "Table already exists"
        return v:false
    endif
    let self.start = line('.')
    let self.end = line('.')
    call system("touch '" . self.path . "'")
    call self.draw()
endfunction

function g:Table.deleteBuffer()
    let l:bufnr = bufnr(self.fileName)
    if bufnr != -1
        try
            exe 'bdelete ' . l:bufnr
        catch
        endtry
    endif
endfunction

function g:Table.delete()
    call self.erase()
    call self.deleteBuffer()
    call system('rm -rf "$HOME/.cache/notes-bin/' . self.fileName . '"')
    call system("mv '" . self.path . "' ~/.cache/notes-bin")
endfunction

function! g:Table.move(newParent)
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
    call self.draw()
    write
endfunction

function g:Table.rename(newName)
    let l:newName = self.formatName(a:newName)
    if strlen(l:newName) == 0
        return v:false
    endif
    let l:newfileName = a:newName . ".tbl"
    let l:newPath = expand("%:p:h") . "/" . l:newfileName
    if filereadable(l:newPath)
        redraw
        echo "Table already exists"
        return v:false
    endif
    call system("mv '" . self.path . "' '" . l:newPath . "'")
    let self.path = l:newPath
    let self.fileName = l:newfileName
    call self.erase()
    call self.draw()
    call self.deleteBuffer()
    return v:true
endfunction

function g:Table.parse(line)
    let l:line = a:line

    let l:end = -1
    let l:lineContent = getline(l:line)
    if l:lineContent =~ '^\s*```$'
        let l:end = l:line
        let l:line -= 1
    endif

    while l:line > 0
        let l:lineContent = getline(l:line)
        if l:lineContent =~ '^\s*```'
            if l:lineContent =~ "^```[A-Za-z0-9_]*.tbl$"
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
    let l:object = g:Page.new()
    if l:object.parse(line('.'))
        return l:object
    endif
    let l:object = g:Table.new()
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
    if type(l:object) == v:null
        echo "Not an object"
        return
    endif
    write
    call l:object.edit()
endfunction

function! OnWinEnter()
    if type(b:editTable) != v:t_dict
        return
    endif
    call b:editTable.erase()
    call b:editTable.draw()
    write
    normal! zz
    let b:editTable = v:null
endfunction

function! TablescriptBacklink()
    write
    exe "norm \<c-6>"
endfunction

function! OnTablescriptEnter()
    nnoremap <silent><buffer><backspace> :call TablescriptBacklink()<CR>
endfunction
