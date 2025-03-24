return require "lazier" {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
        local tsc = require("treesitter-context")
        tsc.setup({
            enable = false,
            multiwindow = false,
            max_lines = 0,
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 20,
            trim_scope = 'outer',
            -- mode = 'cursor',
            mode = 'topline',
            separator = '╌',
            zindex = 20,
            on_attach = nil,
        })
        vim.keymap.set("n", "<leader>tc", vim.cmd.TSContextToggle)
        vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
        vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "Comment" })
    end
}
