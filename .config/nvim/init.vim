" ooooo      ooo                                  o8o                    
" `888b.     `8'                                  `"'                    
"  8 `88b.    8   .ooooo.   .ooooo.  oooo    ooo oooo  ooo. .oo.  .oo.   
"  8   `88b.  8  d88' `88b d88' `88b  `88.  .8'  `888  `888P"Y88bP"Y88b  
"  8     `88b.8  888ooo888 888   888   `88..8'    888   888   888   888  
"  8       `888  888    .o 888   888    `888'     888   888   888   888  
" o8o        `8  `Y8bod8P' `Y8bod8P'     `8'     o888o o888o o888o o888o 

" SETTINGS {{{1

let mapleader = " "

set foldmethod=marker               " use {{{ and }}} for folding
set lazyredraw                      " run macros without updating screen
set clipboard^=unnamed,unnamedplus  " make vim use system clipboard
set encoding=utf-8                  " unicode characters
set hidden                          " allow buffer switching without saving
set backspace=indent,eol,start      " make backspace work as expected
set ttimeoutlen=1                   " time waited for terminal codes
set shortmess+=I                    " remove start page
set showmatch                       " show matching brackets
set guioptions=c!                   " remove gvim widgets
set noshowmode                      " hide --insert--
set laststatus=0                    " hide statusbar
set cursorline                      " highlight current line
set belloff=all                     " disable sound
set nojoinspaces                    " stop double space when joining sentences
set noswapfile                      " disable the .swp files vim creates
set updatetime=300                  " quicker cursorhold events
set title                           " set window title according to titlestring
set titlestring=%t%(\ %M%)          " title, modified
set splitright                      " open horizontal splits to the right
set splitbelow                      " open vertical splits below
set mouse=a                         " enable mouse
set mousemodel=extend               " remove right click menu
set ruler                           " commandline ruler
"set rulerformat=%l,%c%v%=%p         " same syntax as statusline
set number                          " show number column
set signcolumn=no                   " highlight line nr instead of signs
set hlsearch                        " highlight search matches
set incsearch                       " show matches while typing
set ignorecase                      " case insensitive search
set smartcase                       " match case when query contains uppercase
set tabstop=8                       " tabs are 8 characters wide
set expandtab                       " expand tabs into spaces
set shiftwidth=4                    " num spaces for tab at start of line
set softtabstop=1                   " num spaces for tab within a line
set smarttab                        " differentiate shiftwidth and softtabstop
set nrformats=bin,hex,unsigned      " ignore negative dash for <c-a> and <c-x>
set listchars+=eol:$

" }}}
" COLORSCHEME {{{

set notermguicolors
set background=dark
syntax on
colorscheme custom

" }}}
" UNDO HISTORY {{{

set undofile                        " keep track of undo after quitting vim
set undodir=~/.config/nvim/undodir  " store undo history in nvim config
set undolevels=5000                 " increase undo history

if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p", 0770)
endif

" }}}
" AUTOCOMMANDS {{{

function RemoveAutoCommenting()
    setlocal fo-=c fo-=r fo-=o
endfunction
autocmd filetype * call RemoveAutoCommenting()

function RestoreCursorPosition()
    if line("'\"") > 0 && line("'\"") <= line("$")
        exe "normal g'\""
        call feedkeys("zz")
    endif
endfunction
autocmd BufReadPost * call RestoreCursorPosition()

autocmd FileType c,cpp,cs,java,php setlocal commentstring=//\ %s

autocmd FileType html let b:match_words
            \ = '<:>,<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'

autocmd FileType blade let b:match_words
            \ = '<!--:-->,<:>,<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,<\'
            \ . '@<=\([^/!][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,@\%(section\s*([^'
            \ . '\,]*)\|if\|unless\|foreach\|forelse\|for\|while\|push\|can\|ca'
            \ . 'nnot\|hasSection\|php\s*(\@!\|verbatim\|component\|slot\|prepe'
            \ . 'nd\):@\%(else\|elseif\|empty\|break\|continue\|elsecan\|elseca'
            \ . 'nnot\)\>:@\%(end\w\+\|stop\|show\|append\|overwrite\),{:},\[:\'
            \ . '],(:)'

" }}}
" SNIPPETS {{{

au FileType python inoremap <c-f><c-j> print("")<left><left>
au FileType php,blade inoremap <c-f><c-j> error_log("");<esc>hhi
au FileType javascript,typescriptreact inoremap <c-f><c-j> console.log("");<esc>hhi
au FileType cpp,c inoremap <c-f><c-j> printf("");<esc>hhi
au FileType java inoremap <c-f><c-j> System.out.println("");<esc>hhi
au FileType bash,sh inoremap <c-f><c-j> echo<space>""<left>

au FileType python inoremap <c-f><c-d> print()<left>
au FileType php,blade inoremap <c-f><c-d> error_log();<esc>hi
au FileType javascript,typescriptreact inoremap <c-f><c-d> console.log();<esc>hi
au FileType cpp,c inoremap <c-f><c-d> printf();<esc>hi
au FileType java inoremap <c-f><c-d> System.out.println();<esc>hi
au FileType bash,sh inoremap <c-f><c-d> echo<space>

au FileType python inoremap <c-f><c-w> while :<left>
au FileType php,blade inoremap <c-f><c-w> while () {<CR>}<esc>k$hhi
au FileType javascript,typescriptreact inoremap <c-f><c-w> while () {<CR>}<esc>k$hhi
au FileType cpp,c,java inoremap <c-f><c-w> while () {<CR>}<esc>k$hhi
au FileType bash,sh inoremap <c-f><c-w> while ; do<CR>done<esc>k$hhhi

au FileType python inoremap <c-f><c-f> for :<left>
au FileType php,blade inoremap <c-f><c-f> for () {<CR>}<esc>k$hhi
au FileType javascript,typescriptreact inoremap <c-f><c-f> for () {<CR>}<esc>k$hhi
au FileType cpp,c,java inoremap <c-f><c-f> for () {<CR>}<esc>k$hhi
au FileType bash,sh inoremap <c-f><c-f> for ; do<CR>done<esc>k$hhhi

au FileType python inoremap <c-f><c-i> if :<esc>i
au FileType php,blade inoremap <c-f><c-i> if () {<CR>}<esc>k$hhi
au FileType javascript,typescriptreact inoremap <c-f><c-i> if () {<CR>}<esc>k$hhi
au FileType cpp,c,java inoremap <c-f><c-i> if () {<CR>}<esc>k$hhi
au FileType bash,sh inoremap <c-f><c-i> if ; then<CR>fi<esc>k$bbi

au FileType python inoremap <c-f><c-o> elif :<esc>i
au FileType php,blade inoremap <c-f><c-o> else if () {<CR>}<esc>k$hhi
au FileType javascript,typescriptreact inoremap <c-f><c-o> else if () {<CR>}<esc>k$hhi
au FileType cpp,c,java inoremap <c-f><c-o> else if () {<CR>}<esc>k$hhi
au FileType bash,sh inoremap <c-f><c-o> elif ; then<esc>bbi

au FileType python inoremap <c-f><c-e> else:<CR>
au FileType php,blade inoremap <c-f><c-e> else {<CR>}<esc>O
au FileType javascript,typescriptreact inoremap <c-f><c-e> else {<CR>}<esc>O
au FileType cpp,c,java inoremap <c-f><c-e> else {<CR>}<esc>O
au FileType bash,sh inoremap <c-f><c-e> else<CR>

" au FileType python inoremap <c-f><c-s>
au FileType php,blade inoremap <c-f><c-s> switch () {<CR>}<esc>k$hhi
au FileType javascript,typescriptreact inoremap <c-f><c-s> switch () {<CR>}<esc>k$hhi
au FileType cpp,c,java inoremap <c-f><c-s> switch () {<CR>}<esc>k$hhi
au FileType bash,sh inoremap <c-f><c-s> case in<CR>esac<esc>k$bhi<space>

" au FileType python inoremap <c-f><c-v>
au FileType php,blade inoremap <c-f><c-v> case tmp:<CR>break;<esc>k$B"_cw
au FileType javascript,typescriptreact inoremap <c-f><c-v> case tmp:<CR>break;<esc>k$B"_cw
au FileType cpp,c,java inoremap <c-f><c-v> case tmp:<CR>break;<esc>k$B"_cw
au FileType bash,sh inoremap <c-f><c-v> )<CR>;;<esc>k$i

au FileType python inoremap <c-f><c-m> def ():<esc>$F(i
au FileType php,blade inoremap <c-f><c-m> function () {<CR>}<esc>k$F(i
au FileType javascript,typescriptreact inoremap <c-f><c-m> function () {<CR>}<esc>k$F(i
au FileType cpp,c,java inoremap <c-f><c-m> () {<CR>}<esc>k$F(i
au FileType bash,sh inoremap <c-f><c-m> () {<CR>}<esc>k$F(i

au FileType python inoremap <c-f><c-l> lambda:<esc>i
au FileType php,blade inoremap <c-f><c-l> function() {<CR>}<esc>k$hhi
au FileType javascript,typescriptreact inoremap <c-f><c-l> () => {<CR>}<esc>k$BBa
" au FileType cpp inoremap <c-f><c-l>
" au FileType c inoremap <c-f><c-l>
" au FileType java inoremap <c-f><c-l>
" au FileType bash inoremap <c-f><c-l>
" au FileType sh inoremap <c-f><c-l>

" }}}
" MAPPINGS {{{1

" zero width space digraph
exe 'digraph zs ' . 0x200b

" toggle cursor column
nnoremap <silent><leader>cc :let &cuc = !&cuc<cr>

" toggle color column
hi ColorColumn ctermfg=NONE ctermbg=233
nnoremap <silent><leader>8 :let &cc = &cc == 0 ? 80 : 0<cr>

" visually select pasted content
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" swap indent with line below
nnoremap <silent><space>s ^dj^v$hpk$p

" clear search highlight
nnoremap <silent><esc> :<C-U>noh<cr>

" make scrolling more reliable (center screen + same distance)
function! Scroll(direction)
    let l:scrolloff = &scrolloff
    set scrolloff=999
    exe "norm 10" . a:direction
    exe "set scrolloff=" . l:scrolloff
endfunction

nnoremap <silent> <c-d> :call Scroll("j")<CR>
nnoremap <silent> <c-u> :call Scroll("k")<CR>
" nnoremap <c-d> M<c-d>
" nnoremap <c-u> M<c-u>

" cgn on current word
nnoremap <silent><leader>n :let @/='\C\<'.expand("<cword>").'\>'<CR>:set hls<CR>cgn
nnoremap <silent><leader>N :let @/='\C\<'.expand("<cword>").'\>'<CR>:set hls<CR>cgN

" cgn on selection
xnoremap <silent><leader>n "zy:let @/=@z<CR>cgn
xnoremap <silent><leader>N "zy:let @/=@z<CR>cgN

" make Y act like D and C
nnoremap Y y$

" easily repeat macro with q
nnoremap Q @q

" ^, $, and %, <c-6> are motions I use all the time
" however, the keys are in awful positions
map gh ^
map gl $
map gm %
nnoremap <c-p> <c-^>

nnoremap H H^
nnoremap M M^
nnoremap L L^

" stop ignorecase for * and #
" # in middle of a word should jump to previous word, not start of current
nnoremap <silent> * :let @/='\C\<' . expand('<cword>') . '\>'<CR>:let v:searchforward=1<CR>n
nnoremap <silent> # "_yiw:let @/='\C\<' . expand('<cword>') . '\>'<CR>:let v:searchforward=0<CR>n

" visual # and * don't yank to default register
vnoremap * "zy/\V<C-R>z<CR>
vnoremap # "zy?\V<C-R>z<CR>

nnoremap <silent> gn "zyiw:let @/='\C\<'.@z.'\>'<CR>:set hls<CR>
vnoremap <silent> gn "zy:let @/='\C'.@z<CR>:set hls<CR>

" I center screen all the time, zz is slow and hurts my finger
noremap gb zz

nnoremap <silent><leader>s z=1<CR><CR>

" dd, yy, cc, etc all take too long since the same key is pressed twice
" use dl, yl, cl etc instead
onoremap l _
onoremap c l

" jump words skipping symbols with ctrl
nnoremap <silent><c-w> :call search("[a-zA-Z0-9_]\\@=\\<", "z")<CR>
nnoremap <silent><c-b> :call search("[a-zA-Z0-9_]\\@=\\<", "b")<CR>
nnoremap <silent><c-e> :call search("[a-zA-Z0-9_]\\>", "z")<CR>
xmap <silent><c-w> <esc><c-w>mzgv`z
xmap <silent><c-b> <esc><c-b>mzgv`z
xmap <silent><c-e> <esc><c-e>mzgv`z

" remap <c-w> since above mappings remove it
noremap g<c-w> <c-w>

" }}}
" VIRTIDX {{{
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

" }}}
" SLIDE {{{

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

" }}}
" POLYGLOT SETTINGS {{{

let g:polyglot_disabled = ['sensible']

" }}}
" PLUGINS {{{

call plug#begin()
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'jwalton512/vim-blade'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-abolish'
Plug 'chaoren/vim-wordmotion'
Plug 'andrewradev/splitjoin.vim'
Plug 'machakann/vim-swap', { 'on': '<plug>(swap-interactive)' }
Plug 'kevinhwang91/nvim-bqf'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'glts/vim-textobj-comment'
Plug 'michaeljsmith/vim-indent-object'
Plug 'junegunn/vim-easy-align', { 'on': '<plug>(EasyAlign)' }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
call plug#end()

" }}}
" LSP {{{

luafile ~/.config/nvim/lsp.lua

" }}}
" NETRW SETTINGS {{{

let g:netrw_banner=0

" }}}
" JAVA HIGHLIGHT SETTINGS {{{

highlight link javatype none
highlight link javatype none
highlight link javaidentifier none
highlight link javadelimiter none

" }}}
" EASY ALIGN SETTINGS {{{

xnoremap <leader><leader> <plug>(EasyAlign)
nnoremap <leader><leader> <plug>(EasyAlign)

" }}}
" SURROUND SETTINGS {{{

" lua require("nvim-surround").setup()
" runtime macros/sandwich/keymap/surround.vim

" }}}
" SWAP SETTINGS {{{

nmap gs <plug>(swap-interactive)

" }}}
" WORDMOTION SETTINGS {{{

let g:wordmotion_prefix = "<space>"

" }}}
" TMUX NAVIGATOR SETTINGS {{{

let g:tmux_navigator_no_mappings = 1

noremap <silent> <m-h> :<C-U>TmuxNavigateLeft<cr>
noremap <silent> <m-j> :<C-U>TmuxNavigateDown<cr>
noremap <silent> <m-k> :<C-U>TmuxNavigateUp<cr>
noremap <silent> <m-l> :<C-U>TmuxNavigateRight<cr>
inoremap <silent> <m-h> <c-o>:<C-U>TmuxNavigateLeft<cr>
inoremap <silent> <m-j> <c-o>:<C-U>TmuxNavigateDown<cr>
inoremap <silent> <m-k> <c-o>:<C-U>TmuxNavigateUp<cr>
inoremap <silent> <m-l> <c-o>:<C-U>TmuxNavigateRight<cr>

" nnoremap <c-w>h <c-w>H
" nnoremap <c-w>j <c-w>J
" nnoremap <c-w>k <c-w>K
" nnoremap <c-w>l <c-w>L
" nnoremap <c-w><c-h> <c-w>H
" nnoremap <c-w><c-j> <c-w>J
" nnoremap <c-w><c-k> <c-w>K
" nnoremap <c-w><c-l> <c-w>L

" }}}
" SPLITJOIN SETTINGS {{{

let g:splitjoin_r_indent_align_args = 0
let g:splitjoin_python_brackets_on_separate_lines = 1
let g:splitjoin_html_attributes_hanging = 1

"}}}
" JFIND {{{

function! OnJFindExit(window, status)
    call nvim_win_close(a:window, 0)
    if a:status == 0
        try
            let l:contents = readfile($HOME . "/.cache/jfind_out")
            exe 'edit ' . l:contents[0]
        catch
            return
        endtry
    endif
endfunction

function! JFind()
    let project = system('~/.config/jfind/jfind-match-project.sh')
    " if project == ""
    "     echo "Unknown project: " . getcwd()
    "     return
    " endif

    let max_width = 118
    let max_height = 26

    let border = "none"
    let col = 0
    let row = 0

    let buf = nvim_create_buf(v:false, v:true)
    let ui = nvim_list_uis()[0]

    if &columns > max_width
        let width = &columns % 2 ? max_width - 1 : max_width
        if &lines > max_height
            let height = &lines % 2 ? max_height - 1 : max_height
            let border = "rounded"
            let col = (ui.width/2) - (width/2) - 1
            let row = (ui.height/2) - (height/2) - 1
        else
            let width = 1000
            let height = 1000
        endif
    else
        let width = 1000
        let height = 1000
    endif

    let opts = {'relative': 'editor',
                \ 'width': width,
                \ 'height': height,
                \ 'col': col,
                \ 'row': row,
                \ 'anchor': 'nw',
                \ 'style': 'minimal',
                \ 'border': border,
                \ }

    let win = nvim_open_win(buf, 1, opts)
    call nvim_win_set_option(win, 'winhl', 'normal:normal')
    if project == ""
        let t = termopen('~/.config/jfind/jfind-recursive.sh',
                    \ {'on_exit': {status, data -> OnJFindExit(win, data)}})
    else
        let t = termopen('~/.config/jfind/jfind-project.sh',
                    \ {'on_exit': {status, data -> OnJFindExit(win, data)}})
    endif
    startinsert
endfunction

function! JFindTmux()
    silent! !~/.config/tmux/popup-jfind-project.sh
    try
        let l:contents = readfile($HOME . "/.cache/jfind_out")
        exe 'edit ' . l:contents[0]
    catch
        return
    endtry
endfunction

function! JFindLineTmux()
    silent! !~/.config/tmux/popup-jfind-line.sh %
    try
        let l:contents = readfile($HOME . "/.cache/jfind_out")
        exec "silent! norm " . l:contents[0] . "Gzozz^"
    catch
        return
    endtry
endfunction

function! JFindSourceTmux()
    silent! !~/.config/tmux/popup-jfind-source.sh
    try
        let l:contents = readfile($HOME . "/.cache/jfind_out")
        exe 'edit ' . l:contents[0]
    catch
        return
    endtry
endfunction

if exists('$TMUX')
    nnoremap <silent><c-f> :call JFindTmux()<cr>
    nnoremap <silent><c-_> :call JFindLineTmux()<cr>
    nnoremap <silent><c-s> :call JFindSourceTmux()<cr>
else
    nnoremap <silent><c-f> :call JFind()<cr>
endif

" }}}
" FORCE GO FILE {{{

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

" }}}
" SYNSTACK {{{

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

command SynID echo synIDattr(synID(line("."), col("."), 1), "name")

" }}}

" vim: foldmethod=marker
