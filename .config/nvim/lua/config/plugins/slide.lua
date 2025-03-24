return require "lazier" {
    "jake-stewart/slide.nvim",
    dir = "~/clones/slide.nvim",
    config = function()
        local slide = require("slide")
        vim.keymap.set({"n", "v", "o"}, "<leader>j", slide.down)
        vim.keymap.set({"n", "v", "o"}, "<leader>k", slide.up)
    end
}
