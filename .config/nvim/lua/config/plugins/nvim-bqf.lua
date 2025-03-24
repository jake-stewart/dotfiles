return require "lazier" {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
        local bqf = require("bqf")

        bqf.setup({
            preview = {
                winblend = 0,
                show_title = true,
                win_height = 999,
                border = "single",
            },
            func_map = {
                open = "o",
                openc = "<CR>",
            }
        })

        vim.api.nvim_create_augroup("BqfCustomKeybinds", {
            clear = true,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "qf",
            group = "BqfCustomKeybinds",
            callback = function()
                vim.keymap.set("n", "<esc>", ":q<CR>", {
                    silent = true,
                    buffer = true,
                })
            end
        })
    end
}
