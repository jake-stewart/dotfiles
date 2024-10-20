local plugin = require("config.util.plugin")

return plugin("jake-stewart/diagnostic-jump.nvim")
    -- :disable()
    :module("diagnostic-jump")
    :map("n", ",", plugin.prev())
    :map("n", "<c-m>", plugin.next())
    :setup({
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
