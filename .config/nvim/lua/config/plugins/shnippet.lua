return require "lazier" {
    "jake-stewart/shnippet.nvim",
    dir = "~/clones/shnippet.nvim",
    event = "VeryLazy",
    opts = {
        leader = "<c-f>",
        keys = {
            ["print"] = "<down>",
            ["debug"] = "<c-d>",
            ["error"] = "<c-x>",
            ["while"] = "<c-w>",
            ["for"] = "<c-f>",
            ["if"] = "<c-i>",
            ["elseif"] = "<c-o>",
            ["else"] = "<c-e>",
            ["switch"] = "<c-s>",
            ["case"] = "<c-v>",
            ["default"] = "<c-b>",
            ["function"] = "<c-m>",
            ["lambda"] = "<c-l>",
            ["class"] = "<c-k>",
            ["struct"] = "<c-h>",
            ["try"] = "<c-t>",
            ["enum"] = "<c-n>"
        }
    }
}
