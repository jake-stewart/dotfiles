local test = require "test"

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "map",
    args = { function(x) return x * 2 end },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = { 2, 4, 6, 8, 10 }
})

test({
    item = array({ "a", "b", "c" }),
    method = "map",
    args = { function(x) return x:upper() end },
    expectedItem = { "a", "b", "c" },
    expectedReturn = { "A", "B", "C" }
})

test({
    item = array({ true, false, true }),
    method = "map",
    args = { function(x) return not x end },
    expectedItem = { true, false, true },
    expectedReturn = { false, true, false }
})

test({
    item = array({ 1, 2, 3 }),
    method = "map",
    args = { function(x) return x + 1 end },
    expectedItem = { 1, 2, 3 },
    expectedReturn = { 2, 3, 4 }
})

test({
    item = array({}),
    method = "map",
    args = { function(x) return x end },
    expectedItem = {},
    expectedReturn = {}
})
