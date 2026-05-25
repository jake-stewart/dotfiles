local test = require "test"

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 2, 2 },
    expectedItem = { 1, 4, 5 },
    expectedReturn = { 2, 3 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 3, 0, 8, 9 },
    expectedItem = { 1, 2, 8, 9, 3, 4, 5 },
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 2, 2, 6, 7 },
    expectedItem = { 1, 6, 7, 4, 5 },
    expectedReturn = { 2, 3 }
})

test({
    item = array({ 1, 2, 3 }),
    method = "splice",
    args = { 6, 1 },
    expectedItem = { 1, 2, 3 },
    expectedReturn = {}
})

test({
    item = array({}),
    method = "splice",
    args = { 1, 0, 1, 2 },
    expectedItem = { 1, 2 },
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 1, 1 },
    expectedItem = { 2, 3, 4, 5 },
    expectedReturn = { 1 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 5, 1 },
    expectedItem = { 1, 2, 3, 4 },
    expectedReturn = { 5 }
})

test({
    item = array({ 1, 2, 3 }),
    method = "splice",
    args = { 2, 1, 9 },
    expectedItem = { 1, 9, 3 },
    expectedReturn = { 2 }
})

test({
    item = array({ 1, 2, 3, 4 }),
    method = "splice",
    args = { 2, 2, 5, 6 },
    expectedItem = { 1, 5, 6, 4 },
    expectedReturn = { 2, 3 }
})

test({
    item = array({ 1, 2, 3 }),
    method = "splice",
    args = { 2, 0 },
    expectedItem = { 1, 2, 3 },
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 2, 2 },
    expectedItem = { 1, 4, 5 },
    expectedReturn = { 2, 3 }
})

test({
    item = array({ "a", "b", "c", "d", "e" }),
    method = "splice",
    args = { 3, 2 },
    expectedItem = { "a", "b", "e" },
    expectedReturn = { "c", "d" }
})

test({
    item = array({ 10, 20, 30, 40 }),
    method = "splice",
    args = { 1, 3 },
    expectedItem = { 40 },
    expectedReturn = { 10, 20, 30 }
})

test({
    item = array({ 1 }),
    method = "splice",
    args = { 1, 1 },
    expectedItem = {},
    expectedReturn = { 1 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 4, 0 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 6, 1 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = {}
})

test({
    item = array({}),
    method = "splice",
    args = { 1, 1 },
    expectedItem = {},
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4 }),
    method = "splice",
    args = { 1, 0 },
    expectedItem = { 1, 2, 3, 4 },
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3 }),
    method = "splice",
    args = { 11, 1 },
    expectedItem = { 1, 2, 3 },
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 2, 10 },
    expectedItem = { 1 },
    expectedReturn = { 2, 3, 4, 5 }
})

test({
    item = array({ 1, 2, 3 }),
    method = "splice",
    args = { 1, 3 },
    expectedItem = {},
    expectedReturn = { 1, 2, 3 }
})

test({
    item = array({ 1, 2, 3, 4 }),
    method = "splice",
    args = { 2, -1 },
    expectedItem = { 1, 2, 3, 4 },
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 2, 100 },
    expectedItem = { 1 },
    expectedReturn = { 2, 3, 4, 5 }
})

test({
    item = array({}),
    method = "splice",
    args = { 1, 0 },
    expectedItem = {},
    expectedReturn = {}
})

test({
    item = array({ 42 }),
    method = "splice",
    args = { 1, 1 },
    expectedItem = {},
    expectedReturn = { 42 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 3, 0 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = {}
})

test({
    item = array({ a = 1, b = 2, c = 3 }),
    method = "splice",
    args = { 1, 1 },
    expectedItem = array({ a = 1, b = 2, c = 3 }),
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 2, 2 },
    expectedItem = { 1, 4, 5 },
    expectedReturn = { 2, 3 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 5, 1 },
    expectedItem = { 1, 2, 3, 4 },
    expectedReturn = { 5 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 1, 1, 6 },
    expectedItem = { 6, 2, 3, 4, 5 },
    expectedReturn = { 1 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 5, 1, 6 },
    expectedItem = { 1, 2, 3, 4, 6 },
    expectedReturn = { 5 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 3, 0, 6, 7 },
    expectedItem = { 1, 2, 6, 7, 3, 4, 5 },
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 1, 3, 6 },
    expectedItem = { 6, 4, 5 },
    expectedReturn = { 1, 2, 3 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 4, 1, 6, 7 },
    expectedItem = { 1, 2, 3, 6, 7, 5 },
    expectedReturn = { 4 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 1, 5, 6 },
    expectedItem = { 6 },
    expectedReturn = { 1, 2, 3, 4, 5 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 1, 2, 6 },
    expectedItem = { 6, 3, 4, 5 },
    expectedReturn = { 1, 2 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "splice",
    args = { 6, 1, 6 },
    expectedItem = { 1, 2, 3, 4, 5, 6 },
    expectedReturn = {}
})
