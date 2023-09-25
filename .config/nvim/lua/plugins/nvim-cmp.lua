return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    event = "InsertEnter",
    config = function()
        local cmp = require('cmp')

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

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-K>'] = cmp.mapping.confirm({ select = false }),
            }),
            Window = {
                completion = cmp.config.window.bordered({
                    winhighlight = "Normal:CmpPmenu,CursorLine:CursorLine,Search:None",
                }),
                documentation = cmp.config.window.bordered({
                    winhighlight = "Normal:CmpPmenu,CursorLine:CursorLine,Search:None",
                }),
            },
            sources = cmp.config.sources(
            {
                { name = 'nvim_lsp' },
                { name = 'vsnip' }
            },
            { { name = 'buffer' } },
            { { name = 'nvim_lsp_signature_help' } }
            ),
            formatting = {
                format = function(entry, vim_item)
                    vim_item.kind = item_icons[vim_item.kind]
                    vim_item.menu = item_sources[entry.source.name]
                    vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
                    return vim_item
                end
            },
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end,
            }
        })
    end
}
