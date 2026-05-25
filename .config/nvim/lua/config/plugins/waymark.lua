return {
    "jake-stewart/waymark.nvim",
    dir = "~/clones/waymark.nvim",
    event = "VeryLazy",
    config = function()
        local wm = require("waymark")
        vim.keymap.set("n", "<m-i>", wm.forwards)
        vim.keymap.set("n", "<m-o>", wm.backwards)
    end
}
