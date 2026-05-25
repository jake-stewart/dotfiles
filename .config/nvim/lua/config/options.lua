local o = vim.o
local g = vim.g

g.mapleader = " "

-- PERFORMANCE
o.history = 10
o.ttimeoutlen = 1
o.lazyredraw = true
o.updatetime = 300
o.shada = "f0,<0,'1,/10,:10,s1,h"

-- SPLITS
o.splitright = true
o.splitbelow = true

-- MOUSE
o.mouse = "a"
o.mousescroll = "ver:1,hor:0"
o.mousemodel = "extend"

-- TITLE
o.title = true
o.titlestring = "%t%( %M%)"

-- UI
o.guicursor = "a:block-blinkwait500-blinkoff500-blinkon500,i:ver1,r:hor1"
o.fillchars = "fold: ,eob:-"
o.laststatus = 0
o.cursorline = true
o.shortmess = o.shortmess .. "I"
o.ruler = true
o.number = true
o.signcolumn = "number"
o.showmode = false
o.belloff = "all"
g.netrw_banner = 0

-- o.listchars = "tab:< >,space:⋅,lead: ,nbsp:+"
o.listchars = "tab:< >,nbsp:+,eol: "
o.list = true

-- LONG LINES
o.wrap = false
o.breakindent = true
o.breakindentopt = "shift:8,sbr"
o.linebreak = true
o.showbreak = ""
o.sidescroll = 0

-- SEARCH
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.magic = false

-- TAB
o.tabstop = 8
o.expandtab = true
o.shiftwidth = 4
o.softtabstop = 1
o.smarttab = true

-- OTHER
o.hidden = true
o.swapfile = false
o.jumpoptions = "stack"
o.clipboard = "unnamed,unnamedplus"
o.nrformats = "bin,hex,unsigned"
o.virtualedit = "block"
-- o.selection = "old"
o.foldmethod = "marker"
o.path = "**"
o.showmatch = true
o.joinspaces = false

g.zig_fmt_autosave = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

vim.schedule(function()
    vim.diagnostic.config({
        virtual_text = false,
        severity_sort = true,
    })
end)

-- require('vim._core.ui2').enable({ enable = true })
