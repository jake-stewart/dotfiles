let g:file_jump_stack = []

function! PushFile()
    let l:filename = expand("%p")
    let l:idx = index(g:file_jump_stack, l:filename)
    if (l:idx >= 0)
        call remove(g:file_jump_stack, l:idx, -1)
    endif
    call add(g:file_jump_stack, l:filename)
endfunction

function! PopFile()
    if len(g:file_jump_stack) <= 1
        echo "Jumpstack empty"
        return
    endif
    call remove(g:file_jump_stack, -1)
    let l:filename = remove(g:file_jump_stack, -1)
    exec "edit " . l:filename
endfunction

au! BufEnter * call PushFile()

nnoremap <silent><leader>o :call PopFile()<CR>
