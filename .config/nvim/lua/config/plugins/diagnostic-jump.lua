return require "lazier" {
    "jake-stewart/diagnostic-jump.nvim",
    config = function()
        local diagnosticJump = require("diagnostic-jump")
        diagnosticJump.setup({
            float = {
                format = function(diagnostic)
                    return diagnostic.message:_split("\n")[1]
                end,
                prefix = "",
                suffix = "",
                focusable = false,
                header = ""
            }
        })
        vim.keymap.set("n", ",", diagnosticJump.prev)
        vim.keymap.set("n", "<c-m>", diagnosticJump.next)
    end
}
