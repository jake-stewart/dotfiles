local plugin = require("config.util.plugin")

return plugin("lukas-reineke/virt-column.nvim")
    :module("virt-column")
    :map("n", "<leader>8", function()
        vim.o.colorcolumn = vim.o.colorcolumn == "" and "80" or ""
    end)
    :setup({})
