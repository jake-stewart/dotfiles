local test = require "test"

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "filter",
    args = { function(x) return x % 2 == 0 end },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = { 2, 4 }
})

test({
    item = array({ "apple", "banana", "cherry" }),
    method = "filter",
    args = { function(x) return x:sub(1, 1) == "b" end },
    expectedItem = { "apple", "banana", "cherry" },
    expectedReturn = { "banana" }
})

test({
    item = array({ true, false, true }),
    method = "filter",
    args = { function(x) return x end },
    expectedItem = { true, false, true },
    expectedReturn = { true, true }
})

test({
    item = array({ 1, 2, 3 }),
    method = "filter",
    args = { function(x) return x > 2 end },
    expectedItem = { 1, 2, 3 },
    expectedReturn = { 3 }
})

test({
    item = array({}),
    method = "filter",
    args = { function(x) return x end },
    expectedItem = {},
    expectedReturn = {}
})

test({
    item = array({ a = 1, b = 2, c = 3, d = 4 }),
    method = "filter",
    args = { function(v) return v % 2 == 0 end },
    expectedItem = { a = 1, b = 2, c = 3, d = 4 },
    expectedReturn = { b = 2, d = 4 }
})

test({
    item = array({ a = "a", b = 1, c = "c" }),
    method = "filter",
    args = { function(v) return type(v) == "string" end },
    expectedItem = { a = "a", b = 1, c = "c" },
    expectedReturn = { a = "a", c = "c" }
})

test({
    item = array({ x = 5, y = 10, 1, 2, 3, 20 }),
    method = "filter",
    args = { function(v) return v < 10 end },
    expectedItem = { x = 5, y = 10, 1, 2, 3, 20 },
    expectedReturn = { 1, 2, 3, x = 5 }
})

test({
    item = array({ a = "A", b = "B", c = 3 }),
    method = "filter",
    args = { function(_, k) return k == "a" or k == "b" end },
    expectedItem = { a = "A", b = "B", c = 3 },
    expectedReturn = { a = "A", b = "B" }
})

test({
    item = array({}),
    method = "filter",
    args = { function() return true end },
    expectedItem = {},
    expectedReturn = {}
})
