vim.g.mapleader = " "

-- PERFORMANCE
vim.o.history = 100
vim.o.ttimeoutlen = 1
vim.o.lazyredraw = true
vim.o.updatetime = 300

-- SPLITS
vim.o.splitright = true
vim.o.splitbelow = true

-- MOUSE
vim.o.mouse = "a"
vim.o.mousescroll = "ver:1,hor:0"
vim.o.mousemodel = "extend"

-- TITLE
vim.o.title = true
vim.o.titlestring = "%t%( %M%)"

-- UI
vim.o.guicursor = "a:block-blinkon250,i:ver1,r:hor1"
vim.o.laststatus = 0
vim.o.cursorline = true
vim.o.shortmess = vim.o.shortmess .. "I"
vim.o.ruler = true
vim.o.number = true
vim.o.signcolumn = "number"
vim.o.showmode = false
vim.o.belloff = "all"
vim.g.netrw_banner = 0
vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
})
-- vim.o.listchars = "tab:< >,space:⋅,lead: ,nbsp:+"
vim.o.listchars = "tab:< >,nbsp:+"
vim.o.list = true

-- LONG LINES
vim.o.wrap = false
vim.o.breakindent = true
vim.o.breakindentopt = "shift:8,sbr"
vim.o.linebreak = true
vim.o.showbreak = ""
vim.o.sidescroll = 0

-- SEARCH
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.magic = false

-- TAB
vim.o.tabstop = 8
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 1
vim.o.smarttab = true

-- OTHER
vim.o.hidden = true
vim.o.swapfile = false
vim.o.jumpoptions = "stack"
vim.o.clipboard = "unnamed,unnamedplus"
vim.o.nrformats = "bin,hex,unsigned"
vim.o.virtualedit = "block"
vim.o.foldmethod = "marker"
vim.o.path = "**"
vim.o.showmatch = true
vim.o.joinspaces = false

vim.g.zig_fmt_autosave = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
