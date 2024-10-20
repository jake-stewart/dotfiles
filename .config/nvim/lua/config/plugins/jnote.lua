local plugin = require("config.util.plugin")

return plugin("jake-stewart/jnote.nvim")
    -- :disable()
    :ft("markdown")
    :dir("~/clones/jnote.nvim/dist")
    :setup()
