local plugin = require("config.util.plugin")

return plugin("chaoren/vim-wordmotion")
    -- :disable()
    :map({ "n", "x", "o" }, "<leader>w")
    :map({ "n", "x", "o" }, "<leader>b")
    :map({ "n", "x", "o" }, "<leader>e")
    :init(function()
        vim.g.wordmotion_prefix = "<leader>"
    end)
    :setup()
