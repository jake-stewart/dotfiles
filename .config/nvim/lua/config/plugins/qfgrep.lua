local plugin = require("config.util.plugin")

return plugin("jake-stewart/QFGrep")
    :disable()
    :lazy(false)
    :init(function()
        vim.g.QFG_hi_prompt = "ctermbg=NONE ctermfg=blue"
        vim.g.QFG_hi_info = "ctermbg=NONE ctermfg=NONE"
        vim.g.QFG_hi_error = "ctermbg=NONE ctermfg=red"
    end)
    :setup()
