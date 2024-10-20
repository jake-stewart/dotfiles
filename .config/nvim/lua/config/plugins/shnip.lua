local plugin = require("config.util.plugin")

local opts = {
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

local shnip = plugin("jake-stewart/shnip.nvim")

for _, v in pairs(opts.keys) do
    shnip:map("i", opts.leader .. v)
end

return shnip:setup(opts)
