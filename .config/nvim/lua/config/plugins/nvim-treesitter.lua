local plugin = require("config.util.plugin")

return plugin("nvim-treesitter/nvim-treesitter")
    -- :disable()
    :module("nvim-treesitter.configs")
    :ft(
        "c", "lua", "php", "cpp", "javascript", "typescript",
        "cs", "python", "typescriptreact", "markdown", "html"
    )
    :setup({
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
    })
