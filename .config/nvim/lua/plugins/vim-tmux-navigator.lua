return {
    'christoomey/vim-tmux-navigator',
    keys = {
        { "<m-h>", ":<C-U>TmuxNavigateLeft<cr>",       mode = "n", silent = true },
        { "<m-j>", ":<C-U>TmuxNavigateDown<cr>",       mode = "n", silent = true },
        { "<m-k>", ":<C-U>TmuxNavigateUp<cr>",         mode = "n", silent = true },
        { "<m-l>", ":<C-U>TmuxNavigateRight<cr>",      mode = "n", silent = true },
        { "<m-h>", ":<C-U>TmuxNavigateLeft<cr>gv",     mode = "v", silent = true },
        { "<m-j>", ":<C-U>TmuxNavigateDown<cr>gv",     mode = "v", silent = true },
        { "<m-k>", ":<C-U>TmuxNavigateUp<cr>gv",       mode = "v", silent = true },
        { "<m-l>", ":<C-U>TmuxNavigateRight<cr>gv",    mode = "v", silent = true },
        { "<m-h>", "<c-o>:<C-U>TmuxNavigateLeft<cr>",  mode = "i", silent = true },
        { "<m-j>", "<c-o>:<C-U>TmuxNavigateDown<cr>",  mode = "i", silent = true },
        { "<m-k>", "<c-o>:<C-U>TmuxNavigateUp<cr>",    mode = "i", silent = true },
        { "<m-l>", "<c-o>:<C-U>TmuxNavigateRight<cr>", mode = "i", silent = true },
    },
    init = function()
        vim.g.tmux_navigator_no_mappings = 1
    end
}
