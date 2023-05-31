function! ForceGoFile(fname)
    let l:path=expand('%:p:h') .'/'. expand(a:fname)
    if filereadable(l:path)
       norm gf
    else
        silent! execute "!touch ". expand(l:path)
        norm gf
    endif
endfunction

noremap <silent><leader>gf :call ForceGoFile(expand("<cfile>"))<cr>
