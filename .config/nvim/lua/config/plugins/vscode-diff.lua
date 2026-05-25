return {
    "jake-stewart/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
        require("codediff").setup({
            highlights = {
                line_insert = "DiffAdd",
                line_delete = "DiffDelete",
                char_insert = "DiffCharAdd",
                char_delete = "DiffCharDelete"
            }
        })
    end
}
