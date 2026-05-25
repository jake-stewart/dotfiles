local test = require "test"

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "reduce",
    args = { function(acc, x) return acc + x end, 0 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = 15
})

test({
    item = array({ 1, 2, 3, 4 }),
    method = "reduce",
    args = { function(acc, x) return acc * x end, 1 },
    expectedItem = { 1, 2, 3, 4 },
    expectedReturn = 24
})

test({
    item = array({}),
    method = "reduce",
    args = { function(acc, x) return acc + x end, 0 },
    expectedItem = {},
    expectedReturn = 0
})

test({
    item = array({ 10, 20, 30 }),
    method = "reduce",
    args = { function(acc, x) return acc - x end, 100 },
    expectedItem = { 10, 20, 30 },
    expectedReturn = 40
})

test({
    item = array({ "a", "b", "c" }),
    method = "reduce",
    args = { function(acc, x) return acc .. x end, "" },
    expectedItem = { "a", "b", "c" },
    expectedReturn = "abc"
})

test({
    item = array({ 1, 2, 3, 10, 4, 5 }),
    method = "reduce",
    args = { function(acc, x) return math.max(acc, x) end },
    expectedItem = { 1, 2, 3, 10, 4, 5 },
    expectedReturn = 10
})
