local test = require("test")

test({
    item = array({ 1, 2, { 3, 4, { 5, 6 } } }),
    method = "flat",
    args = { 1 },
    expectedItem = { 1, 2, { 3, 4, { 5, 6 } } },
    expectedReturn = { 1, 2, 3, 4, { 5, 6 } }
})

test({
    item = array({ 1, { 2, { 3 } }, 4 }),
    method = "flat",
    args = { 2 },
    expectedItem = { 1, { 2, { 3 } }, 4 },
    expectedReturn = { 1, 2, 3, 4 }
})

test({
    item = array({ { 1, 2 }, { 3, 4 } }),
    method = "flat",
    args = { 1 },
    expectedItem = { { 1, 2 }, { 3, 4 } },
    expectedReturn = { 1, 2, 3, 4 }
})

test({
    item = array({ 1, { 2, { 3, 4 } }, 5 }),
    method = "flat",
    args = { 3 },
    expectedItem = { 1, { 2, { 3, 4 } }, 5 },
    expectedReturn = { 1, 2, 3, 4, 5 }
})

test({
    item = array({ 1, 2, 3 }),
    method = "flat",
    args = { 0 },
    expectedItem = { 1, 2, 3 },
    expectedReturn = { 1, 2, 3 }
})

test({
    item = array({ { { 1 } } }),
    method = "flat",
    args = { 1 },
    expectedItem = { { { 1 } } },
    expectedReturn = { { 1 } }
})

test({
    item = array({}),
    method = "flat",
    args = { 1 },
    expectedItem = {},
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "flat",
    args = { 1 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = { 1, 2, 3, 4, 5 }
})

test({
    item = array({ 1, { 2, { 3 } }, 4 }),
    method = "flat",
    args = { 1 },
    expectedItem = { 1, { 2, { 3 } }, 4 },
    expectedReturn = { 1, 2, { 3 }, 4 }
})
