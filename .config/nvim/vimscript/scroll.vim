" make scrolling more reliable (center screen + same distance)
function! Scroll(direction)
    let l:scrolloff = &scrolloff
    set scrolloff=999
    exe "norm 10" . a:direction
    exe "set scrolloff=" . l:scrolloff
endfunction

nnoremap <silent><c-d> :call Scroll("j")<CR>
nnoremap <silent><c-u> :call Scroll("k")<CR>
