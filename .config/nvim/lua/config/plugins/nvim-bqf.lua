local plugin = require("config.util.plugin")

return plugin("kevinhwang91/nvim-bqf")
    -- :disable()
    :ft("qf")
    :module("bqf")
    :setup(function(bqf)
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

        bqf.setup({
            preview = {
                winblend = 0,
                show_title = true,
                win_height = 999,
                border_chars = {
                    "│",
                    "│",
                    "─",
                    "─",
                    "┌",
                    "┐",
                    "└",
                    "┘",
                    "█",
                },
            },
            func_map = {
                open = "o",
                openc = "<CR>",
            }
        })
    end)

