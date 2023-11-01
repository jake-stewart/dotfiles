local function toggleColorColumn()
    vim.o.colorcolumn = vim.o.colorcolumn == "" and "80" or ""
end

return {
    "lukas-reineke/virt-column.nvim",
    keys = {
        { "<space>8", toggleColorColumn, { mode = "n" } }
    },
    config = function()
        require("virt-column").setup()
    end
}
