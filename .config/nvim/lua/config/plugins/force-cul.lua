local plugin = require("config.util.plugin")

return plugin("jake-stewart/force-cul.nvim")
    -- :disable()
    :dir("~/clones/force-cul.nvim")
    :module("force-cul")
    :event("VeryLazy")
    :setup({})

