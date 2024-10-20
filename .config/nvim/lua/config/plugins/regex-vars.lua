local plugin = require("config.util.plugin")

local EMAIL_REGEX
    = "[a-zA-Z0-9_.+-]+\\@[a-zA-Z0-9-]+\\.[a-zA-Z0-9.-]+"

return plugin("jake-stewart/regex-vars.nvim")
    -- :disable()
    :module("regex-vars")
    :dir("~/clones/regex-vars.nvim")
    :map({"n", "v"}, "/")
    :setup(function(rv)
        rv.setup({
            [rv.escape(":email:")] = EMAIL_REGEX
        })
    end)
