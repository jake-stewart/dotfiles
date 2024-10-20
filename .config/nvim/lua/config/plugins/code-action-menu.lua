local plugin = require("config.util.plugin")

return plugin("weilbith/nvim-code-action-menu")
    -- :disable()
    :map("n", "<leader>f", function()
        vim.cmd.CodeActionMenu()
    end)
    :setup(function()
        vim.g.code_action_menu_window_border = "none"
        vim.g.code_action_menu_show_details = false
        vim.g.code_action_menu_show_diff = false
        vim.g.code_action_menu_show_action_kind = false
    end)
