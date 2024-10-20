local plugin = require("config.util.plugin")

return plugin("Wansmer/treesj")
    :module("treesj")
    :map("n", "gJ", function() vim.cmd.TSJJoin() end)
    :map("n", "gS", function() vim.cmd.TSJSplit() end)
    :setup({
        use_default_keymaps = false,
        check_syntax_error = true,
        max_join_length = math.huge,
        cursor_behavior = "start",
        notify = false,
        dot_repeat = true
    })
