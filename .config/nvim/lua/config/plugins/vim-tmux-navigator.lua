local plugin = require("config.util.plugin")

local function bind(keys, cmd)
    local callback = function()
        local success, mc = pcall(require, "multicursor-nvim")
        if success then
            mc.action(function()
                return vim.cmd[cmd]()
            end)
        else
            vim.cmd[cmd]()
        end
    end
    return {"n", "v", "i"}, keys, callback
end

return plugin("christoomey/vim-tmux-navigator")
    :map(bind("<m-h>", "TmuxNavigateLeft"))
    :map(bind("<m-j>", "TmuxNavigateDown"))
    :map(bind("<m-k>", "TmuxNavigateUp"))
    :map(bind("<m-l>", "TmuxNavigateRight"))
    :init(function()
        vim.g.tmux_navigator_no_mappings = 1
    end)
    :setup()
