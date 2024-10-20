local plugin = require("config.util.plugin")

local ITEM_ICONS = {
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

local ITEM_SOURCES = {
    buffer = "[BUF]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[LUA]",
}

local WINHIGHLIGHT = vim.iter({
    Normal = "Pmenu",
    FloatBorder = "Pmenu",
    CursorLine = "PmenuSel",
    Search = "None",
})
    :map(function(k, v) return k .. ":" .. v end)
    :join(",")

return plugin("hrsh7th/nvim-cmp")
    -- :disable()
    :module("cmp")
    :deps(
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help"
    )
    :event("InsertEnter")
    :setup(function(cmp)
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<up>"] = cmp.mapping.confirm({
                    select = false,
                })
            }),
            window = {
                completion = {
                    winhighlight = WINHIGHLIGHT,
                    max_height = 10,
                    scrollbar = false,
                },
                documentation = {
                    winhighlight = WINHIGHLIGHT,
                    scrollbar = false,
                },
            },
            sources = cmp.config.sources({
                {name = "nvim_lsp"},
                {name = "buffer"},
                {name = "nvim_lsp_signature_help"},
                {name = "lazydev", group_index = 0}
            }),
            formatting = {
                format = function(entry, vim_item)
                    vim_item.kind = ITEM_ICONS[vim_item.kind]
                    vim_item.menu = ITEM_SOURCES[entry.source.name]
                    vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
                    return vim_item
                end
            },
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
                end
            }
        })
    end)
