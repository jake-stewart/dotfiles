local plugin = require("config.util.plugin")

return plugin("jake-stewart/vim-abolish")
    :map("n", "cr")
    :cmd("S", "Subvert")
    :setup()
