local test = require "test"

test({
    item = "foo",
    method = "pad_right",
    args = { 5 },
    expectedItem = "foo",
    expectedReturn = "foo  "
})

test({
    item = "bar",
    method = "pad_right",
    args = { 6, "-" },
    expectedItem = "bar",
    expectedReturn = "bar---"
})

test({
    item = "test",
    method = "pad_right",
    args = { 4, "0" },
    expectedItem = "test",
    expectedReturn = "test"
})

test({
    item = "",
    method = "pad_right",
    args = { 3, "x" },
    expectedItem = "",
    expectedReturn = "xxx"
})

test({
    item = "hello",
    method = "pad_right",
    args = { 10, " " },
    expectedItem = "hello",
    expectedReturn = "hello     "
})

test({
    item = "world",
    method = "pad_right",
    args = { 8, "0" },
    expectedItem = "world",
    expectedReturn = "world000"
})

