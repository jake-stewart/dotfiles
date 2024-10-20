local plugin = require("config.util.plugin")

return plugin("jake-stewart/ctrl-g.nvim")
    -- :disable()
    :module("ctrl-g")
    :map("n", "<c-g>")
    :setup({})

