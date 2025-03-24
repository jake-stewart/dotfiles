return require "lazier" {
    "jake-stewart/jnote.nvim",
    enabled = false,
    dir = "~/clones/jnote.nvim/dist",
    ft = "markdown",
    config = function()
        require("jnote").setup()
    end
}
