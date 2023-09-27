return {
    "Wansmer/treesj",
    keys = {
        { "gJ", vim.cmd.TSJJoin },
        { "gS", vim.cmd.TSJSplit },
    },
    config = function()
        require("treesj").setup({
            use_default_keymaps = false,
            check_syntax_error = true,
            max_join_length = math.huge,
            cursor_behavior = 'start',
            notify = false,
            dot_repeat = true,
        })
    end,
}
