return {
    "jake-stewart/auto-cmdheight.nvim",
    dir = "~/clones/auto-cmdheight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("auto-cmdheight").setup({
            max_lines = 8,
            duration = 2,
            remove_on_key = true,
            clear_always = true,
        })
    end
}
