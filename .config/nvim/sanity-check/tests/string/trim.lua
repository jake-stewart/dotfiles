local test = require "test"

test({
    item = "  foo",
    method = "trim",
    args = { },
    expectedItem = "  foo",
    expectedReturn = "foo"
})

test({
    item = "  foo bar baz",
    method = "trim",
    args = { },
    expectedItem = "  foo bar baz",
    expectedReturn = "foo bar baz"
})

test({
    item = "  foo bar baz   ",
    method = "trim",
    args = { },
    expectedItem = "  foo bar baz   ",
    expectedReturn = "foo bar baz"
})

test({
    item = "foo   bar  baz   ",
    method = "trim",
    args = { },
    expectedItem = "foo   bar  baz   ",
    expectedReturn = "foo   bar  baz"
})
