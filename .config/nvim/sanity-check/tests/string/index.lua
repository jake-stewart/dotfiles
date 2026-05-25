local test = require "test"

test({
    item = "hello world",
    method = "index",
    args = { "world" },
    expectedItem = "hello world",
    expectedReturn = 7
})

test({
    item = "foo bar baz",
    method = "index",
    args = { "bar" },
    expectedItem = "foo bar baz",
    expectedReturn = 5
})

test({
    item = "abcdef",
    method = "index",
    args = { "e" },
    expectedItem = "abcdef",
    expectedReturn = 5
})

test({
    item = "test string",
    method = "index",
    args = { "notfound" },
    expectedItem = "test string",
    expectedReturn = nil
})

test({
    item = "example example",
    method = "index",
    args = { "exam" },
    expectedItem = "example example",
    expectedReturn = 1
})

test({
    item = "aaaaa",
    method = "index",
    args = { "aa" },
    expectedItem = "aaaaa",
    expectedReturn = 1
})

test({
    item = "hello world",
    method = "index",
    args = { "o", 6 },
    expectedItem = "hello world",
    expectedReturn = 8
})

test({
    item = "foo bar baz",
    method = "index",
    args = { "bar", 3 },
    expectedItem = "foo bar baz",
    expectedReturn = 5
})

test({
    item = "abcdef",
    method = "index",
    args = { "c", 4 },
    expectedItem = "abcdef",
    expectedReturn = nil
})

test({
    item = "test string",
    method = "index",
    args = { "t", 2 },
    expectedItem = "test string",
    expectedReturn = 4
})

test({
    item = "example example",
    method = "index",
    args = { "exam", 3 },
    expectedItem = "example example",
    expectedReturn = 9
})

test({
    item = "hello hello hello",
    method = "index",
    args = { "hello", 8 },
    expectedItem = "hello hello hello",
    expectedReturn = 13
})

