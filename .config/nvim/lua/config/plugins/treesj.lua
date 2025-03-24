return require "lazier" {
    "Wansmer/treesj",
    config = function()
        require("treesj").setup({
            use_default_keymaps = false,
            check_syntax_error = true,
            max_join_length = math.huge,
            cursor_behavior = "start",
            notify = false,
            dot_repeat = true,
        })
        vim.keymap.set("n", "gJ", vim.cmd.TSJJoin)
        vim.keymap.set("n", "gS", vim.cmd.TSJSplit)
    end
}
