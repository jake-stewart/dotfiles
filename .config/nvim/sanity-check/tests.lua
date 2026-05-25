local test = require("test")

require "tests.table.splice"
require "tests.table.map"
require "tests.table.filter"
require "tests.table.reduce"
require "tests.table.slice"
require "tests.table.flat"
require "tests.table.index"
require "tests.table.lastIndex"

require "tests.string.trim"
require "tests.string.padLeft"
require "tests.string.padRight"
require "tests.string.index"
require "tests.string.lastIndex"
require "tests.string.replace"
require "tests.string.split"

vim.print(test.numPasses .. "/" .. test.numTests .. " test" .. (test.numTests == 1 and "" or "s") .. " passed.")
