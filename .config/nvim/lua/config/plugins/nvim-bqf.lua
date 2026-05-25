return {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
        local bqf = require("bqf")

        vim.api.nvim_set_hl(0, "BqfPreviewFloat", { link = "GreyBg1" })
        vim.api.nvim_set_hl(0, "BqfPreviewBorder", { link = "Border" })
        vim.api.nvim_set_hl(0, "BqfPreviewRange", { link = "IncSearch" })
        vim.api.nvim_set_hl(0, "BqfPreviewTitle", vim.tbl_extend("keep",
            vim.api.nvim_get_hl(0, { name = "Title" }),
            vim.api.nvim_get_hl(0, { name = "GreyBg3" })
        ))

        bqf.setup({
            preview = { --- @diagnostic disable-line
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
