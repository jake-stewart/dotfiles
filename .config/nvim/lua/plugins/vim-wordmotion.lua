return {
    'chaoren/vim-wordmotion',
    init = function()
        vim.g.wordmotion_prefix = "<leader>"
    end,
    keys = {
        { "<leader>w", mode = {"n", "x", "o"} },
        { "<leader>b", mode = {"n", "x", "o"} },
        { "<leader>e", mode = {"n", "x", "o"} },
    },
}
