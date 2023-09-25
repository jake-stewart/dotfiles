" ooooo      ooo              o8o                    
" `888b.     `8'              `"'                    
"  8 `88b.    8  oooo    ooo oooo  ooo. .oo.  .oo.   
"  8   `88b.  8   `88.  .8'  `888  `888P"Y88bP"Y88b  
"  8     `88b.8    `88..8'    888   888   888   888  
"  8       `888     `888'     888   888   888   888  
" o8o        `8      `8'     o888o o888o o888o o888o 
"
" ooooooooo.                                           
" `888   `Y88.                                         
"  888   .d88'  .oooo.    .oooooooo  .ooooo.  oooo d8b 
"  888ooo88P'  `P  )88b  888' `88b  d88' `88b `888""8P 
"  888          .oP"888  888   888  888ooo888  888     
"  888         d8(  888  `88bod8P'  888    .o  888     
" o888o        `Y888""8o `8oooooo.  `Y8bod8P' d888b    
"                        d"     YD                     
"                        "Y88888P'                     

" SETTINGS {{{

lua nvimpager.maps = false
let g:no_man_maps = 1

set foldmethod=manual               " hide automatic folds
set clipboard^=unnamed,unnamedplus  " make vim use system clipboard
set lazyredraw                      " run macros without updating screen
set encoding=utf-8                  " unicode characters
set ttimeoutlen=1                   " time waited for terminal codes
set guioptions=c!                   " remove gvim widgets
set noshowmode                      " hide --INSERT--
set laststatus=0                    " hide statusbar
set belloff=all                     " disable sound
set noswapfile                      " disable the .swp files vim creates
set title                           " set window title according to titlestring
set titlestring=%t%(\ %M%)          " title, modified
set splitright                      " open horizontal splits to the right
set splitbelow                      " open vertical splits below
set mouse=a                         " enable mouse
set mousemodel=extend               " remove right click menu
set noruler                         " hide commandline ruler
set rulerformat=%l,%c%V%=%P         " same syntax as statusline
set hlsearch                        " highlight search matches
set incsearch                       " show matches while typing
set ignorecase                      " case insensitive search
set smartcase                       " match case when query contains uppercase
set tabstop=8                       " tabs are 8 characters wide
set expandtab                       " expand tabs into spaces
set shiftwidth=4                    " num spaces for tab at start of line
set softtabstop=1                   " num spaces for tab within a line
set smarttab                        " differentiate shiftwidth and softtabstop

" }}}
" APPEARANCE {{{

set background=dark
syntax on
colorscheme custom

hi Comment gui=italic cterm=italic
hi Todo gui=italic cterm=italic

" }}}
" KEYBINDS {{{

let g:searchMode = v:false

function! UnhookSearch()
    cunmap <cr>
    cunmap <esc>
endfunction

function! HookSearch(success, fail)
    exe 'cnoremap <silent><esc> <c-c>:call UnhookSearch()<CR>' .. a:fail
    exe 'cnoremap <silent><cr> <cr>:call UnhookSearch()<CR>' .. a:success
endfunction

function! SearchMode()
    let g:searchMode = v:true
    set cursorline
    noremap gh ^
    noremap gl $
    noremap gm %
endf

function! StartSearch()
    call SearchMode()
    call HookSearch("", ":call PagerMode()<CR>")
endfunction

function! PagerMode()
    set nocursorline
    let g:searchMode = v:false
    try
        nunmap gh
        nunmap gl
        nunmap gm
    catch | endtry
    call feedkeys("L0", "nt")
endfunction

let s:unmap_keys = [
        \ "c", "d", "o", "p", "r", "s", "x", "y",
        \ "z", "A", "C", "D", "I", "J", "O", "P",
        \ "Q", "R", "S", "U", "X", "Z", "-", "=",
        \ "[", "]", ".", "@", "&", "_",
    \ ]

let s:toggle_keys = [
        \ "b", "e", "h", "l", "m", "t", "w", "B",
        \ "E", "F", "K", "T", "W", "Y", ";", "'",
        \ ",", "`", "#", "$", "%", "^", "*", "(",
        \ ")", "+", "{", "}", "<", ">", "~", "<!>",
    \ ]

for s:key in s:unmap_keys
    exe 'map ' . s:key . ' <NOP>'
endfor

for s:key in s:toggle_keys
    exe 'nnoremap <expr>' . s:key . ' g:searchMode ? "' .. s:key .. '" : ""'
endfor

nnoremap i <NOP>

" make search only match once per line
noremap / H:<c-u>call StartSearch()<cr>/
noremap ? L:<c-u>call StartSearch()<cr>?

nnoremap <silent>a :call PagerMode()<CR>

noremap <silent><expr>H g:searchMode ? "H" : ":call SearchMode()<CR>H"
noremap <silent><expr>M g:searchMode ? "M" : ":call SearchMode()<CR>M"
noremap <silent><expr>L g:searchMode ? "M" : ":call SearchMode()<CR>L"

" q and ctrl + c quits program
nnoremap <silent>q <cmd>qa!<CR>
cnoremap <silent><c-c> <cmd>qa!<CR>
nnoremap <silent><c-c> <cmd>qa!<CR>

" clear search highlight
nnoremap <silent><expr><esc> g:searchMode ? ":call PagerMode()<CR>" : ":noh<CR>"

" yank visual
xnoremap <silent>y y:call PagerMode()<CR>

" bind u/d to ctrl+u/d
nnoremap <silent>d <c-d>:call PagerMode()<CR>
nnoremap <silent>u <c-u>:call PagerMode()<CR>

nnoremap <silent><expr>j g:searchMode ? "j" : "<c-e>L0"
nnoremap <silent><expr>k g:searchMode ? "k" : "<c-y>L0"

noremap <silent><expr>g g:searchMode ? "g" : "ggL0"
noremap <silent><expr>G g:searchMode ? "G" : "zbGL0"

nnoremap <silent><expr>zt &cul ? "zt" : ""
nnoremap <silent><expr>zb &cul ? "zb" : ""
nnoremap <silent><expr>zz &cul ? "zz" : ""

function! OnVimEnter()
    try
        unmap gx
        unmap g%
    catch | endtry
    norm k
endfunction

au VimEnter * call OnVimEnter()

" }}}

" vim: foldmethod=marker
