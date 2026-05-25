local test = require "test"

test({
    item = "hello world",
    method = "last_index",
    args = { "o" },
    expectedItem = "hello world",
    expectedReturn = 8
})

test({
    item = "foo bar baz",
    method = "last_index",
    args = { "bar" },
    expectedItem = "foo bar baz",
    expectedReturn = 5
})

test({
    item = "abcdef",
    method = "last_index",
    args = { "f" },
    expectedItem = "abcdef",
    expectedReturn = 6
})

test({
    item = "test string",
    method = "last_index",
    args = { "notfound" },
    expectedItem = "test string",
    expectedReturn = nil
})

test({
    item = "example example",
    method = "last_index",
    args = { "exam" },
    expectedItem = "example example",
    expectedReturn = 9
})

test({
    item = "aaaaa",
    method = "last_index",
    args = { "a" },
    expectedItem = "aaaaa",
    expectedReturn = 5
})

test({
    item = "aaaaa",
    method = "last_index",
    args = { "aa" },
    expectedItem = "aaaaa",
    expectedReturn = 4
})

test({
    item = "foo foo",
    method = "last_index",
    args = { "foo" },
    expectedItem = "foo foo",
    expectedReturn = 5
})

test({
    item = "foo fooo",
    method = "last_index",
    args = { "foo" },
    expectedItem = "foo fooo",
    expectedReturn = 5
})

test({
    item = "hello world",
    method = "last_index",
    args = { "o", 1 },
    expectedItem = "hello world",
    expectedReturn = nil
})

test({
    item = "bar foo bar baz bar foo",
    method = "last_index",
    args = { "bar", 13 },
    expectedItem = "bar foo bar baz bar foo",
    expectedReturn = 9
})

test({
    item = "barbarbarbar",
    method = "last_index",
    args = { "bar", 6 },
    expectedItem = "barbarbarbar",
    expectedReturn = 4
})

test({
    item = "barbarbarbar",
    method = "last_index",
    args = { "bar", 5 },
    expectedItem = "barbarbarbar",
    expectedReturn = 1
})

test({
    item = "barbarbarbar",
    method = "last_index",
    args = { "bar", 4 },
    expectedItem = "barbarbarbar",
    expectedReturn = 1
})

test({
    item = "barbarbarbar",
    method = "last_index",
    args = { "bar", 3 },
    expectedItem = "barbarbarbar",
    expectedReturn = 1
})

test({
    item = "barbarbarbar",
    method = "last_index",
    args = { "bar", 2 },
    expectedItem = "barbarbarbar",
    expectedReturn = nil
})

test({
    item = "foobarbarbarbarbarbarbarbarbarbarbarbarbar",
    method = "last_index",
    args = { "foo" },
    expectedItem = "foobarbarbarbarbarbarbarbarbarbarbarbarbar",
    expectedReturn = 1
})

test({
    item = "barbarbarbarbarbarbarbarbarbarbarbarbarfoo",
    method = "last_index",
    args = { "foo" },
    expectedItem = "barbarbarbarbarbarbarbarbarbarbarbarbarfoo",
    expectedReturn = 40
})
