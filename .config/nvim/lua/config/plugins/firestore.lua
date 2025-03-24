return require "lazier" {
    "delphinus/vim-firestore",
    enabled = false,
    ft = "firestore",
    init = function()
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*.rules",
            callback = function()
                vim.o.filetype = "firestore"
            end
        })
    end
}
