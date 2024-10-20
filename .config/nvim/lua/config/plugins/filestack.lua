local plugin = require("config.util.plugin")

return plugin("jake-stewart/filestack.nvim")
    -- :disable()
    :dir("~/clones/filestack.nvim")
    :event("VeryLazy")
    :module("filestack")
    :setup({})
