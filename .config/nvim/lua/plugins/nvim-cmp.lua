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
            Field = "V",
            Variable = "V",
            Property = "V",
            Constant = "V",
            EnumMember = "V",
            Enum = "E",
            Class = "C",
            Interface = "I",
            Struct = "S",
            Method = "F",
            Function = "F",
            Constructor = "F",
            Text = " ",
            Module = " ",
            Unit = " ",
            Value = " ",
            Keyword = " ",
            Snippet = "*",
            Color = " ",
            File = " ",
            Reference = " ",
            Folder = " ",
            Event = " ",
            Operator = " ",
            TypeParameter = " "
        }

        local item_sources = {
            buffer   = "[BUF]",
            nvim_lsp = "[LSP]",
            nvim_lua = "[LUA]",
        }

        local winhighlight
            = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None"

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<up>'] = cmp.mapping.confirm({ select = false }),
            }),
            window = {
                completion = {
                    winhighlight = winhighlight,
                    max_height = 10,
                    scrollbar = false,
                },
                documentation = {
                    winhighlight = winhighlight,
                    scrollbar = false,
                },
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
