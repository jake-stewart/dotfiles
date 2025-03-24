return require "lazier" {
    -- enabled = false,
    dir = "~/projects/fuzzline",
    keys = {
        { "<c-_>", function()
            vim.print("what")
            require("fuzzline").fuzzline()
        end }
    }
}
