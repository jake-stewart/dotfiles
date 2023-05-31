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
" SEARCH {{{

function! MapSearch()
    set cursorline
    cnoremap <silent><cr> <cr>:call UnmapSearch()<cr>
    cnoremap <silent><esc> <c-c>:call UnmapSearch()<cr>L0
endf

function! UnmapSearch()
    cunmap <cr>
    cunmap <esc>
endf

function! SearchNext()
    if &cursorline
        return "$n"
    else
        set cursorline
        return "H$n"
    endif
endf

function! SearchPrev()
    if &cursorline
        return "0N"
    else
        set cursorline
        return "H0N"
    endif
endf

" }}}
" KEYBINDS {{{

" unmap unused keys
let s:unmap_keys = [
        \ "a", "b", "c", "d", "e", "h", "i", "l",
        \ "m", "o", "p", "r", "s", "t", "w", "x",
        \ "y", "z", "A", "B", "C", "D", "E", "F",
        \ "H", "I", "J", "K", "L", "M", "O", "P",
        \ "Q", "R", "S", "T", "U", "W", "X", "Y",
        \ "Z", "-", "=", "[", "]", ";", "'", ",",
        \ ".", "`", "@", "#", "$", "%", "^", "&",
        \ "*", "(", ")", "_", "+", "{", "}", "<",
        \ ">", "~", "<!>",
        \ "<bslash>", "<bar>", "\""
    \ ]
for s:key in s:unmap_keys
    exe 'nnoremap ' . s:key . ' <NOP>'
endfor

" make search only match once per line
noremap / H:<c-u>call MapSearch()<cr>/

nnoremap <silent><expr>n SearchNext()
nnoremap <silent><expr>N SearchPrev()

" q and ctrl + c quits program
nnoremap <silent>q <cmd>qa!<CR>
cnoremap <silent><c-c> <cmd>qa!<CR>
nnoremap <silent><c-c> <cmd>qa!<CR>

" clear search highlight
nnoremap <silent><esc> :set nocul<CR>:noh<CR>L0
xnoremap <silent><esc> <esc>:set nocul<CR>:noh<CR>L0

" yank visual
xnoremap <silent>y y:set nocul<CR>:noh<CR>L0

xnoremap gh ^
xnoremap gl $
xnoremap gm %

" bind u/d to ctrl+u/d
nnoremap <silent>d :set nocul<CR><c-d>L0
nnoremap <silent>u :set nocul<CR><c-u>L0

nnoremap <silent>j :set nocul<CR><c-e>L0
nnoremap <silent>k :set nocul<CR><c-y>L0

nnoremap <silent>gg :set nocul<CR>ggL0
nnoremap <silent>G GztL0:set nocul<CR>

nnoremap <silent><expr>zt &cul ? "zt" : ""
nnoremap <silent><expr>zb &cul ? "zb" : ""
nnoremap <silent><expr>zz &cul ? "zz" : ""
nnoremap <silent><expr>gb &cul ? "zz" : "" " }}}

au VimEnter * norm k

" vim: foldmethod=marker
