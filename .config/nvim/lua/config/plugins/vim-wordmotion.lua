return require "lazier" {
    "chaoren/vim-wordmotion",
    keys = {
        {"<leader>w", mode = { "n", "x", "o" }},
        {"<leader>b", mode = { "n", "x", "o" }},
        {"<leader>e", mode = { "n", "x", "o" }}
    },
    init = function()
        vim.g.wordmotion_prefix = "<leader>"
    end
}
