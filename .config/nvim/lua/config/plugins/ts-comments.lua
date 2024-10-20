local plugin = require("config.util.plugin")

return plugin("folke/ts-comments.nvim")
    :module("ts-comments")
    :event("VeryLazy")
    :setup({})
