local EMAIL_REGEX
    = "[a-zA-Z0-9_.+-]+\\@[a-zA-Z0-9-]+\\.[a-zA-Z0-9.-]+"

local QUOTE_REGEX = "['\"`]"

local BOOL_REGEX = "(true|false)"
local STRING_REGEX = "('[^']*'|\"[^\"]*\"|`[^`]*`)"
local INT_REGEX = "(\\d+|0x\\d+)"
local NUM_REGEX = "((\\d+(\\.\\d*)?|\\.\\d+)(e\\d+)?|0x\\d+|\\d+)"

return require "lazier" {
    "jake-stewart/regex-vars.nvim",
    dir = "~/clones/regex-vars.nvim",
    keys = {{ "/", mode = {"n", "v"} }},
    lazy = false,
    config = function()
        local rv = require("regex-vars")
        rv.setup({
            ["\\email"] = EMAIL_REGEX,
            ["\\q"] = QUOTE_REGEX,
            ["\\bool"] = BOOL_REGEX,
            ["\\str"] = STRING_REGEX,
            ["\\num"] = NUM_REGEX,
            ["\\int"] = INT_REGEX,
        })
        -- rv.test()
    end
}
