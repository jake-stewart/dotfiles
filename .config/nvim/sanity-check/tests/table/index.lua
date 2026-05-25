local test = require "test"

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "index",
    args = { 3 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = 3
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "index",
    args = { 6 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = nil
})

test({
    item = array({ 1, 1, 1, 1, 1 }),
    method = "index",
    args = { 1 },
    expectedItem = { 1, 1, 1, 1, 1 },
    expectedReturn = 1
})

test({
    item = array({}),
    method = "index",
    args = { 1 },
    expectedItem = {},
    expectedReturn = nil
})

test({
    item = array({ 5, 4, 3, 2, 1 }),
    method = "index",
    args = { 5 },
    expectedItem = { 5, 4, 3, 2, 1 },
    expectedReturn = 1
})

test({
    item = array({ 1, 2, 3, 4, 5, 2 }),
    method = "index",
    args = { 2 },
    expectedItem = { 1, 2, 3, 4, 5, 2 },
    expectedReturn = 2
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "index",
    args = { 4 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = 4
})

test({
    item = array({ 1, 2, 3, 2, 1 }),
    method = "index",
    args = { 2 },
    expectedItem = { 1, 2, 3, 2, 1 },
    expectedReturn = 2
})

test({
    item = array({ 1, 2, 3, 4, 5 }),
    method = "index",
    args = { 1 },
    expectedItem = { 1, 2, 3, 4, 5 },
    expectedReturn = 1
})
