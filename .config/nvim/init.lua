local function sourceVimscript(name)
    local dir = "$HOME/.config/nvim/vimscript/"
    vim.cmd.source(dir .. name .. ".vim")
end

require("autocommands")
require("colors")
require("options")
require("mappings")
require("plugins")
require("snippets")

sourceVimscript("jfind")
sourceVimscript("slide")
sourceVimscript("forceGoFile")
sourceVimscript("scroll")
sourceVimscript("filestack")
