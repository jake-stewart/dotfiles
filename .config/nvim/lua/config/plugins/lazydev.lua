local plugin = require("config.util.plugin")

return plugin("folke/lazydev.nvim")
    -- :disable()
    :ft("lua")
    :module("lazydev")
    :setup({
        library = {
            "lazy.nvim",
            "luvit-meta/library",
        }
    })
