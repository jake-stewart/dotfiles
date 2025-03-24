return require "lazier" {
    "nvim-treesitter/nvim-treesitter",
    ft = {
        "c", "lua", "php", "cpp", "javascript", "typescript",
        "cs", "python", "typescriptreact", "markdown", "html"
    },
    opts = {
        ensure_installed = {
            "c",
            "c_sharp",
            "lua",
            "php",
            "cpp",
            "javascript",
            "typescript",
            "html",
            "markdown",
            "markdown_inline"
        },
        sync_install = false,
        auto_install = true,
        indent = {
            enable = true,
            disable = { "python" },
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = { "vimdoc", "vim", "css" },
        }
    }
}
