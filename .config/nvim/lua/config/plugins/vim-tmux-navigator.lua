return require "lazier" {
    "christoomey/vim-tmux-navigator",
    config = function()
        vim.g.tmux_navigator_no_mappings = 1

        local function bind(keys, callback)
            vim.keymap.set({"n", "v", "i"}, keys, function()
                if package.loaded["multicursor-nvim"] then
                    local success, mc = pcall(require, "multicursor-nvim")
                    if success then
                        mc.action(function()  end)
                    end
                end
                callback()
            end)
        end

        bind("<m-h>", vim.cmd.TmuxNavigateLeft)
        bind("<m-j>", vim.cmd.TmuxNavigateDown)
        bind("<m-k>", vim.cmd.TmuxNavigateUp)
        bind("<m-l>", vim.cmd.TmuxNavigateRight)
    end
}

