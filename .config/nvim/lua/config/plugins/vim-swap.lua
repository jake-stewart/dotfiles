return require "lazier" {
    "machakann/vim-swap",
    config = function()
        vim.keymap.set("n", "gs", "<plug>(swap-interactive)")
    end
}
