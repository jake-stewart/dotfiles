local test = require "test"

test({
    item = "foo,bar,baz",
    method = "split",
    args = { "," },
    expectedItem = "foo,bar,baz",
    expectedReturn = { "foo", "bar", "baz" }
})

test({
    item = "foo,bar,baz",
    method = "split",
    args = { "bar" },
    expectedItem = "foo,bar,baz",
    expectedReturn = { "foo,", ",baz" }
})

test({
    item = "foobar",
    method = "split",
    args = {},
    expectedItem = "foobar",
    expectedReturn = { "f", "o", "o", "b", "a", "r" }
})

test({
    item = "foo,bar.baz",
    method = "split_re",
    args = { vim.regex("[,.]") },
    expectedItem = "foo,bar.baz",
    expectedReturn = { "foo", "bar", "baz" }
})

test({
    item = "afoobbarcbazd",
    method = "split_re",
    args = { vim.regex("\\v(foo|bar|baz)") },
    expectedItem = "afoobbarcbazd",
    expectedReturn = { "a", "b", "c", "d" }
})

test({
    item = ",foo,bar,baz,",
    method = "split",
    args = { ",", true },
    expectedItem = ",foo,bar,baz,",
    expectedReturn = { "foo", "bar", "baz" }
})

test({
    item = "foo,bar,baz",
    method = "split",
    args = { "bar", true },
    expectedItem = "foo,bar,baz",
    expectedReturn = { "foo,", ",baz" }
})

test({
    item = ",,,foo,bar.,.baz.",
    method = "split_re",
    args = { vim.regex("[,.]"), true },
    expectedItem = ",,,foo,bar.,.baz.",
    expectedReturn = { "foo", "bar", "baz" }
})

test({
    item = "foofooafoobbarcbazdbarbar",
    method = "split_re",
    args = { vim.regex("\\v(foo|bar|baz)"), true },
    expectedItem = "foofooafoobbarcbazdbarbar",
    expectedReturn = { "a", "b", "c", "d" }
})
