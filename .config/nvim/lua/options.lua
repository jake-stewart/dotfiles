vim.g.mapleader = " "

vim.o.path = "**"
vim.o.foldmethod = "marker"               -- use {{{ and }}} for folding
vim.o.lazyredraw = true                   -- run macros without updating screen
vim.o.clipboard = "unnamed,unnamedplus"   -- make vim use system clipboard
vim.o.encoding = "utf-8"                  -- unicode characters
vim.o.hidden = true                       -- allow buffer switching without saving
vim.o.backspace = "indent,eol,start"      -- make backspace work as expected
vim.o.ttimeoutlen = 1                     -- time waited for terminal codes
vim.o.shortmess = vim.o.shortmess .. "I"  -- remove start page
vim.o.showmatch = true                    -- show matching brackets
--vim.o.guioptions="c"                      -- remove gvim widgets
vim.o.showmode = false                    -- hide --insert--
vim.o.laststatus = 0                      -- hide statusbar
vim.o.cursorline = true                   -- highlight current line
vim.o.belloff="all"                       -- disable sound
vim.o.joinspaces = false                  -- stop double space when joining sentences
vim.o.swapfile = false                    -- disable the .swp files vim creates
vim.o.updatetime=300                      -- quicker cursorhold events
vim.o.title = true                        -- set window title according to titlestring
vim.o.titlestring = "%t%( %M%)"           -- title, modified
vim.o.splitright = true                   -- open horizontal splits to the right
vim.o.splitbelow = true                   -- open vertical splits below
vim.o.mouse = "a"                         -- enable mouse
vim.o.mousemodel = "extend"               -- remove right click menu
vim.o.ruler = true                        -- commandline ruler
vim.o.number = true                       -- show number column
vim.o.signcolumn = "no"                   -- highlight line nr instead of signs
vim.o.hlsearch = true                     -- highlight search matches
vim.o.incsearch = true                    -- show matches while typing
vim.o.ignorecase = true                   -- case insensitive search
vim.o.smartcase = true                    -- match case when query contains uppercase
vim.o.tabstop = 8                         -- tabs are 8 characters wide
vim.o.expandtab = true                    -- expand tabs into spaces
vim.o.shiftwidth = 4                      -- num spaces for tab at start of line
vim.o.softtabstop = 1                     -- num spaces for tab within a line
vim.o.smarttab = true                     -- differentiate shiftwidth and softtabstop
vim.o.nrformats = "bin,hex,unsigned"      -- ignore negative dash for <c-a> and <c-x>
vim.o.listchars = vim.o.listchars .. ",eol:$"
vim.o.jumpoptions = "stack"
vim.o.virtualedit = "block"

vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.breakindentopt = "shift:8"

-- UNDO HISTORY
vim.o.undofile = true -- keep track of undo after quitting vim
vim.o.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"  -- store undo history in nvim config
vim.o.undolevels = 5000                 -- increase undo history
if not vim.fn.isdirectory(vim.fn.expand(vim.o.undodir)) then
    vim.fn.mkdir(vim.fn.expand(vim.o.undodir), "p", 0770)
end

vim.g.netrw_banner = 0

vim.diagnostic.config({
  virtual_text = false,
})
