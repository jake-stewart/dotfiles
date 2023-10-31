return {
    "jake-stewart/normon.nvim",
    keys = {
        {"<leader>n", mode = {"n", "v"}},
        {"<leader>N", mode = {"n", "v"}},
        {"<leader>q", mode = {"n", "v"}},
        {"<leader>Q", mdoe = {"n", "v"}},
        {"*", mode = {"n", "v"}},
        {"#", mode = {"n", "v"}},
        {"<leader>dgn", mode = {"n", "v"}},
        {"<leader>dgN", mdoe = {"n", "v"}},
    },
    config = function()
        local normon = require("normon")
        normon("<leader>n", "cgn")
        normon("<leader>N", "cgN")
        normon("<leader>q", "q")
        normon("<leader>Q", "q", {backward = true})
        normon("*", "n")
        normon("#", "n", {backward = true})
        normon("<leader>dgn", "dgn")
        normon("<leader>dgN", "dgN")

        vim.keymap.set("v", "g*", "*")
        vim.keymap.set("v", "g#", "#")
    end
}
