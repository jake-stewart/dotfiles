return require "lazier" {
    "junegunn/vim-easy-align",
    enabled = false,
    config = function()
        vim.keymap.set({ "n", "v" }, "<leader>a", "<plug>(EasyAlign)")
    end
}
