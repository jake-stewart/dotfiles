return require "lazier" {
    "lewis6991/gitsigns.nvim",
    config = function()
        local state = {
            signs_enabled = false
        }

        local gs = require("gitsigns")
        gs.setup({
            signs = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" }
            },
            signs_staged = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" }
            },
            signs_staged_enable = true,
            signcolumn = false,
            numhl = false,
            linehl = false,
            word_diff = false,
            watch_gitdir = { follow_files = true },
            auto_attach = true,
            attach_to_untracked = false,
            current_line_blame = false,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 200,
                ignore_whitespace = false,
                virt_text_priority = 100
            },
            current_line_blame_formatter
                = "<author>, <author_time:%R> - <summary>",
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,
            max_file_length = 40000,
            preview_config = {
                border = "solid", -- none, single, solid
                style = "minimal",
                relative = "cursor",
                anchor = "SW",
                row = 0,
                col = 0
            }
        })

        vim.keymap.set("n", "<leader>gs", function ()
            state.signs_enabled = not state.signs_enabled
            gs.toggle_signs(state.signs_enabled)
            vim.api.nvim_echo(
                {{
                    "Git signs " .. (state.signs_enabled and "enabled" or "disabled"),
                    state.signs_enabled and "DiffAdd" or "DiffDelete"
                }}, false, {})
        end)
        vim.keymap.set("n", "<leader>go", gs.setqflist)
        vim.keymap.set("n", "<leader>gd", gs.diffthis)
        vim.keymap.set("n", "<leader>gb", gs.blame_line)
        vim.keymap.set("n", "<leader>gB", gs.blame)
        vim.keymap.set("n", "<leader>gn",
            function() gs.nav_hunk('next') end)
        vim.keymap.set("n", "<leader>gp",
            function() gs.nav_hunk('prev') end)
        vim.keymap.set("n", "<leader>gh", gs.preview_hunk)
        vim.keymap.set("n", "<leader>gO", function()
            local topLevel = vim.fn.systemlist(
                "git rev-parse --show-toplevel")[1]
            local paths = vim.v.shell_error == 0
                and vim.fn.systemlist("git diff --name-only")
                or {}
            table(paths)
                :_map(function(item) return { filename = topLevel .. "/" .. item } end)
                :_pipe(vim.fn.setqflist)
            vim.cmd.copen()
        end)
    end
}
