return {
    --"https://github.com/jake-stewart/comment.nvim",
    dir = "~/projects/fuzzybuf",
    enabled = false,
    config = function()
        require("fuzzybuf").setup({})
    end
}
