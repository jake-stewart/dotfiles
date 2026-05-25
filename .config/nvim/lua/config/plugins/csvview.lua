return {
    "hat0uma/csvview.nvim",
    config = function()
        require('csvview').setup()
        vim.api.nvim_create_autocmd("BufReadPost", {
            pattern = "*.csv",
            callback = function()
                vim.cmd("CsvViewEnable display_mode=border")
            end
        })
    end
}
