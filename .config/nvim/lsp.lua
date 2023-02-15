local item_icons = {
    Text = " ",
    Method = "m",
    Function = "f",
    Constructor = "c",
    Field = "f",
    Variable = "v",
    Class = "C",
    Interface = "I",
    Module = "M",
    Property = "p",
    Unit = "u",
    Value = " ",
    Enum = "E",
    Keyword = "k",
    Snippet = " ",
    Color = "c",
    File = "F",
    Reference = "r",
    Folder = "D",
    EnumMember = "E",
    Constant = "c",
    Struct = "S",
    Event = "e",
    Operator = "o",
    TypeParameter = "t"
}

local item_sources = {
    buffer   = "[BUF]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[LUA]",
}

local cmp = require('cmp')
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources(
        {{ name = 'nvim_lsp' }},
        {{ name = 'buffer' }},
        {{ name = 'nvim_lsp_signature_help' }}
    ),
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = item_icons[vim_item.kind]
            vim_item.menu = item_sources[entry.source.name]
            vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
            return vim_item
        end
    }
})

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>[', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>]', vim.diagnostic.goto_next, opts)

local lsp_setup = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = function(client, bufnr)
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', 'K',  vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    end,
}

require('lspconfig').clangd.setup(lsp_setup)
require('lspconfig').jdtls.setup(lsp_setup)
require('lspconfig').pyright.setup(lsp_setup)
require('lspconfig').tsserver.setup(lsp_setup)
require('lspconfig').intelephense.setup(lsp_setup)

require('bqf').setup({
    preview = {
        show_title = true,
        win_height = 999,
        border_chars = {
            '│', '│', '─', '─', '┌', '┐', '└', '┘', '█'
        },
    }
})

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        "c",
        "lua",
        "help",
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
