local EMAIL_REGEX
    = "[a-zA-Z0-9_.+-]+\\@[a-zA-Z0-9-]+\\.[a-zA-Z0-9.-]+"

local QUOTE_REGEX = "['\"`]"

local BOOL_REGEX = "(true|false)"
local STRING_REGEX = "('[^']*'|\"[^\"]*\"|`[^`]*`)"
local INT_REGEX = "(\\d+|0x\\d+)"
local NUM_REGEX = "((\\d+(\\.\\d*)?|\\.\\d+)(e\\d+)?|0x\\d+|\\d+)"

return require "lazier" {
    "jake-stewart/regex-vars.nvim",
    keys = { "/", mode = {"n", "v"} },
    config = function()
        local rv = require("regex-vars")

        rv.setup({
            [rv.escape("\\email")] = EMAIL_REGEX,
            [rv.escape("\\q")] = QUOTE_REGEX,
            [rv.escape("\\bool")] = BOOL_REGEX,
            [rv.escape("\\str")] = STRING_REGEX,
            [rv.escape("\\num")] = NUM_REGEX,
            [rv.escape("\\int")] = INT_REGEX,
        })
    end
}
