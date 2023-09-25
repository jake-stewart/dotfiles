return {
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    ft = { "c", "lua", "php", "cpp", "javascript", "typescript", "cs", "python", "typescriptreact" },
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                "c",
                "c_sharp",
                "lua",
                "php",
                "cpp",
                "javascript",
                "typescript",
            },
            sync_install = false,
            auto_install = true,
            indent = {
                enable = true,
                disable = {
                    "python"
                },
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                disable = {
                    "vim", "css"
                },
            },
        })
    end,
}
