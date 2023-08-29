require("autocommands")
require("colors")
require("options")
require("mappings")
require("plugins")
require("snippets")

vim.cmd([[

let g:macro_keys = "qwerty"
let g:macro_depth = 0
let g:macros = []

function! StartMacro()
    let l:keys = 'q' .. g:macro_keys[g:macro_depth]
    if g:macro_depth == 0
        let g:macros = [""]
        nnoremap <expr>q EndMacro()
        nnoremap <expr>2q StartMacro()
        nnoremap <expr>Q ReplayMacro()
    else
        if len(g:macros) < g:macro_depth + 1
            call add(g:macros, "")
        else
            g:macros[g:macro_depth + 1] = ""
        endif
        call feedkeys('q', 'nx')
        let l:macro = getreg(g:macro_keys[g:macro_depth - 1])
        if l:macro =~ "^.*2q$"
            let l:macro = l:macro[:-3]
        elseif l:macro =~ "^.*2$"
            let l:macro = l:macro[:-2]
        endif
        let g:macros[g:macro_depth - 1] ..= l:macro
    endif
    let g:macro_depth += 1
    return l:keys
endfunction

function! ReplayMacro()
    call feedkeys('q', 'nx')
    let l:macro = getreg(g:macro_keys[g:macro_depth - 1])[:-2]
    let g:macros[g:macro_depth - 1] ..= l:macro .. "@" .. g:macro_keys[g:macro_depth]
    call feedkeys("@" .. g:macro_keys[g:macro_depth], "m")
    return "q" .. g:macro_keys[g:macro_depth - 1]
endfunction

function! EndMacro()
    if g:macro_depth == 0
        return
    endif

    call feedkeys('q', 'nx')
    let l:keys = ''
    let g:macro_depth -= 1

    let g:macros[g:macro_depth] ..= getreg(g:macro_keys[g:macro_depth])
    call setreg(g:macro_keys[g:macro_depth], g:macros[g:macro_depth])

    if g:macro_depth == 0
        nunmap 2q
        nnoremap <expr>q StartMacro()
        nmap <expr>Q @q
    else
        let g:macros[g:macro_depth - 1] ..= "@" .. g:macro_keys[g:macro_depth]
        let l:keys ..= 'q' .. g:macro_keys[g:macro_depth - 1]
    endif

    return l:keys
endfunction

nnoremap <expr>q StartMacro()

]])
