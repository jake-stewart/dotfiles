function! VirtIdx(string, idx)
    if len(a:string) == 0
        return ' '
    endif
    let l:idx = 0
    for char in a:string
        if char == "\t"
            let l:idx = (l:idx / &ts + 1) * &ts
        else
            let l:idx += strdisplaywidth(char)
        endif

        if l:idx >= a:idx
            break
        endif
    endfor
    return char
endfunction

function! Slide(direction, smart_syntax)
    let l:syntax = a:smart_syntax && exists("*synstack")

    let l:col = col('.')
    let l:line = line('.')
    let l:max_line = line('$')

    if l:syntax
        let l:stack = synstack(line('.'), col('.'))
    endif

    if l:col > 1
        let l:char_before = VirtIdx(getline(l:line), l:col - 1)
        let l:space_before = (l:char_before == ' '
                    \ || l:char_before == ''
                    \ || l:char_before == "\t")
    endif

    let l:char_after = VirtIdx(getline(l:line), l:col)
    let l:space_after = (l:char_after == ' '
                \ || l:char_after == ''
                \ || l:char_after == "\t")

    while 1
        let l:line += a:direction

        if l:line > l:max_line || l:line == 0
            break
        endif

        if strdisplaywidth(getline(l:line)) < l:col - 1
            break
        endif

        if l:syntax
            let l:newstack = synstack(l:line, l:col)
            if len(l:newstack) == 0
                if len(l:stack) > 0
                    let g:bruh = 1
                    break
                endif
            elseif len(l:stack) == 0
                let g:bruh = 2
                break
            elseif l:stack[-1] != l:newstack[-1]
                let g:bruh = 3
                break
            endif
        endif

        let l:char_after = VirtIdx(getline(l:line), l:col)
        let l:new_space_after = (l:char_after == ' '
                    \ || l:char_after == ''
                    \ || l:char_after == "\t")
        if l:new_space_after != l:space_after
            break
        endif

        if l:col > 1
            let l:char_before = VirtIdx(getline(l:line), l:col - 1)
            let l:new_space_before = (l:char_before == ' '
                        \ || l:char_before == ''
                        \ || l:char_before == "\t")
            if l:new_space_before != l:space_before
                break
            endif
        endif
    endwhile

    if a:direction == 1
        let l:jump = l:line - line('.') - 1
        let l:jump_char = 'j'
    else
        let l:jump = line('.') - l:line - 1
        let l:jump_char = 'k'
    endif

    if l:jump == 0
        return ''
    elseif l:jump == 1
        return l:jump_char
    else
        return l:jump . l:jump_char
    endif
endfunction

nnoremap <expr><leader>J Slide(1, 0)
vnoremap <expr><leader>J Slide(1, 0)
nnoremap <expr><leader>K Slide(-1, 0)
vnoremap <expr><leader>K Slide(-1, 0)

nnoremap <expr><leader>j Slide(1, 1)
vnoremap <expr><leader>j Slide(1, 1)
nnoremap <expr><leader>k Slide(-1, 1)
vnoremap <expr><leader>k Slide(-1, 1)
