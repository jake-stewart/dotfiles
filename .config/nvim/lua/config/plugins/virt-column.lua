return require "lazier" {
    "lukas-reineke/virt-column.nvim",
    config = function()
        require("virt-column").setup({})
        vim.keymap.set("n", "<leader>8", function()
            vim.o.colorcolumn = vim.o.colorcolumn == "" and "80" or ""
        end)
    end
}
