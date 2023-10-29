return {
    "https://github.com/jake-stewart/shnip.nvim",
    config = function()
        require("shnip").setup({
            leader = "<c-f>",
            keys = {
                ["print"]    = "<down>",
                ["debug"]    = "<c-d>",
                ["error"]    = "<c-x>",
                ["while"]    = "<c-w>",
                ["for"]      = "<c-f>",
                ["if"]       = "<c-i>",
                ["elseif"]   = "<c-o>",
                ["else"]     = "<c-e>",
                ["switch"]   = "<c-s>",
                ["case"]     = "<c-v>",
                ["default"]  = "<c-b>",
                ["function"] = "<c-m>",
                ["lambda"]   = "<c-l>",
                ["class"]    = "<c-k>",
                ["struct"]   = "<c-h>",
                ["try"]      = "<c-t>",
                ["enum"]     = "<c-n>"
            }
        })
        require("shnip").snippet("<c-p>", "()<left>")
    end
}
