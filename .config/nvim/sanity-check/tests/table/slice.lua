local test = require "test"

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "slice",
    args = { 1, 3 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = { 1, 2, 3 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "slice",
    args = { 0, 2 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = { 1, 2 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "slice",
    args = { 3, 5 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = { 3, 4, 5 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "slice",
    args = { 1, 5 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = { 1, 2, 3, 4, 5 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "slice",
    args = { 0, 0 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = {}
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "slice",
    args = { 2, 2 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = { 2 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "slice",
    args = { 5, 5 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = { 5 }
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "slice",
    args = { 2, 10 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = { 2, 3, 4, 5 }
})

