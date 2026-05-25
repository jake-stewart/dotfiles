return {
    "christoomey/vim-tmux-navigator",
    init = function()
        vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
        local keys = {
            ["<m-h>"] = vim.cmd.TmuxNavigateLeft,
            ["<m-j>"] = vim.cmd.TmuxNavigateDown,
            ["<m-k>"] = vim.cmd.TmuxNavigateUp,
            ["<m-l>"] = vim.cmd.TmuxNavigateRight,
        }
        for key, callback in pairs(keys) do
            vim.keymap.set({"n", "v", "i"}, key, function()
                local mc = package.loaded["multicursor-nvim"]
                if mc then
                    mc.action(function() callback() end)
                else
                    callback()
                end
            end)
        end
    end
}

