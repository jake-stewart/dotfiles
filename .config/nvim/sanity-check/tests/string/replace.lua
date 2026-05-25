local test = require "test"

test({
    item = "hello world",
    method = "replace",
    args = { "world", "there" },
    expectedItem = "hello world",
    expectedReturn = "hello there"
})

test({
    item = "foo bar baz",
    method = "replace",
    args = { "bar", "qux" },
    expectedItem = "foo bar baz",
    expectedReturn = "foo qux baz"
})

test({
    item = "ab.def",
    method = "replace",
    args = { ".", "c" },
    expectedItem = "ab.def",
    expectedReturn = "abcdef"
})

test({
    item = "test string",
    method = "replace",
    args = { "notfound", "new" },
    expectedItem = "test string",
    expectedReturn = "test string"
})

test({
    item = "example example",
    method = "replace",
    args = { "exam", "sample" },
    expectedItem = "example example",
    expectedReturn = "sampleple sampleple"
})

test({
    item = "aaaaa",
    method = "replace",
    args = { "a", "b" },
    expectedItem = "aaaaa",
    expectedReturn = "bbbbb"
})

test({
    item = "hello hello hello",
    method = "replace",
    args = { "hello", "hi" },
    expectedItem = "hello hello hello",
    expectedReturn = "hi hi hi"
})

test({
    item = "substring test test",
    method = "replace",
    args = { "test", "exam" },
    expectedItem = "substring test test",
    expectedReturn = "substring exam exam"
})

test({
    item = "hello @world!",
    method = "replace",
    args = { "@world", "#there" },
    expectedItem = "hello @world!",
    expectedReturn = "hello #there!"
})

test({
    item = "foo & bar",
    method = "replace",
    args = { "&", "and" },
    expectedItem = "foo & bar",
    expectedReturn = "foo and bar"
})

test({
    item = "abc$def",
    method = "replace",
    args = { "$", "@" },
    expectedItem = "abc$def",
    expectedReturn = "abc@def"
})

test({
    item = "!@$^.*$*@&#$^.><>",
    method = "replace",
    args = { ".*$", "foo" },
    expectedItem = "!@$^.*$*@&#$^.><>",
    expectedReturn = "!@$^foo*@&#$^.><>"
})

test({
    item = "escape \\ backslash",
    method = "replace",
    args = { "\\", "/" },
    expectedItem = "escape \\ backslash",
    expectedReturn = "escape / backslash"
})

test({
    item = "a^b^c",
    method = "replace",
    args = { "^", "~" },
    expectedItem = "a^b^c",
    expectedReturn = "a~b~c"
})

test({
    item = "hello \nworld",
    method = "replace",
    args = { "\n", " " },
    expectedItem = "hello \nworld",
    expectedReturn = "hello  world"
})

test({
    item = "quotes \"here\"",
    method = "replace",
    args = { "\"", "'" },
    expectedItem = "quotes \"here\"",
    expectedReturn = "quotes 'here'"
})

test({
    item = "fooooobar",
    method = "replace_re",
    args = { vim.regex("fo*"), "baz" },
    expectedItem = "fooooobar",
    expectedReturn = "bazbar"
})

test({
    item = "fooooobarfoobarfobar",
    method = "replace_re",
    args = { vim.regex("fo*"), "baz" },
    expectedItem = "fooooobarfoobarfobar",
    expectedReturn = "bazbarbazbarbazbar"
})

test({
    item = "foobarbaz",
    method = "replace_re",
    args = { vim.regex("^baz"), "test" },
    expectedItem = "foobarbaz",
    expectedReturn = "foobarbaz"
})

test({
    item = "foobarfoo",
    method = "replace_re",
    args = { vim.regex("^foo"), "bar" },
    expectedItem = "foobarfoo",
    expectedReturn = "barbarfoo"
})

test({
    item = "foofoofoo",
    method = "replace",
    args = { "foo", "bar", 2 },
    expectedItem = "foofoofoo",
    expectedReturn = "barbarfoo"
})

test({
    item = "foofoofoo",
    method = "replace_re",
    args = { vim.regex("foo"), "bar", 2 },
    expectedItem = "foofoofoo",
    expectedReturn = "barbarfoo"
})

test({
    item = "foo bar baz",
    method = "replace_re",
    args = { vim.regex("\\v(foo|baz)"), "bingo", 2 },
    expectedItem = "foo bar baz",
    expectedReturn = "bingo bar bingo"
})

test({
    item = "abc",
    method = "replace_re",
    args = { vim.regex("."), function(_, i) return i end },
    expectedItem = "abc",
    expectedReturn = "123"
})

test({
    item = "aaa",
    method = "replace",
    args = { "a", function(_, i) return i end },
    expectedItem = "aaa",
    expectedReturn = "123"
})

test({
    item = "a b c",
    method = "replace_re",
    args = { vim.regex("[a-z]"), function(s) return s .. s end },
    expectedItem = "a b c",
    expectedReturn = "aa bb cc"
})

test({
    item = "a a a",
    method = "replace",
    args = { "a", function(s) return s .. s end },
    expectedItem = "a a a",
    expectedReturn = "aa aa aa"
})
