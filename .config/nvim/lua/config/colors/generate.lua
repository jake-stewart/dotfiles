--- @diagnostic disable unused locals

local function color(name)
    return {
        fg = function(...)
            return { fg = name, ... }
        end,
        bg = function(...)
            return { bg = name, ... }
        end,
    }
end

local function attr(name)
    return function(...)
        return { [name] = true, ... }
    end
end

local function sign(name, text)
    return { sign = name, text = text }
end

local italic = attr("italic")
local bold = attr("bold")
local underline = attr("underline")
local undercurl = attr("undercurl")
local reverse = attr("reverse")
local strikethrough = attr("strikethrough")

local black = color("darkblack")
local red = color("darkred")
local green = color("darkgreen")
local yellow = color("darkyellow")
local blue = color("darkblue")
local magenta = color("darkmagenta")
local cyan = color("darkcyan")
local white = color("darkwhite")

local bright_black = color("black")
local bright_red = color("red")
local bright_green = color("green")
local bright_yellow = color("yellow")
local bright_blue = color("blue")
local bright_magenta = color("magenta")
local bright_cyan = color("cyan")
local bright_white = color("white")

local function rgb(r, g, b)
    return color(16 + r * 36 + g * 6 + b)
end

local function grey(shade)
    return color(232 + shade)
end

--- @diagnostic enable unused locals

local function generate_theme(t)
    local highlights = {}
    local function flatten(group, parent)
        local opts = {
            ctermfg = group.fg or parent.ctermfg,
            ctermbg = group.bg or parent.ctermbg,
            cterm = {
                bold = group.bold or parent.cterm.bold,
                italic = group.italic or parent.cterm.italic,
                underline = group.underline or parent.cterm.underline,
                undercurl = group.undercurl or parent.cterm.undercurl,
                strikethrough = group.strikethrough or parent.cterm.strikethrough,
                reverse = group.reverse or parent.cterm.reverse
            }
        }
        local highlight = { opts = opts, signs = {} }
        for _, item in ipairs(group) do
            if type(item) == "string" then
                if highlight.name then
                    table.insert(highlight, item)
                else
                    highlight.name = item
                end
            elseif item.sign then
                if highlight.name then
                    table.insert(highlight, item.sign)
                else
                    highlight.name = item.sign
                end
                table.insert(highlight.signs, item)
            else
                flatten(item, opts)
            end
        end
        if highlight.name then
            table.insert(highlights, highlight)
        end
    end
    flatten(t, {
        ctermfg = "NONE",
        ctermbg = "NONE",
        cterm = {},
    })

    local serializer = require("lazier.util.serializer")

    local src = {
        serializer.assignment("vim.g.colors_name", "custom")[1],
        serializer.assignment("vim.o.background", "dark")[1],
        serializer.assignment("vim.o.termguicolors", false)[1],
        "local hl = vim.api.nvim_set_hl",
        "local sign = vim.fn.sign_define",
        "local link"
    }
    for _, highlight in ipairs(highlights) do
        if vim.tbl_count(highlight.opts.cterm) == 0 then
            highlight.opts.cterm = nil
        end
        if highlight.opts.ctermfg == "NONE" then
            highlight.opts.ctermfg = nil
        end
        if highlight.opts.ctermbg == "NONE" then
            highlight.opts.ctermbg = nil
        end
        table.insert(src, serializer.function_call("hl", 0, highlight.name, highlight.opts)[1])
        if #highlight > 0 then
            table.insert(src, "link = " .. serializer.serialize({ link = highlight.name }))
            for _, item in ipairs(highlight) do
                table.insert(src, serializer.function_call("hl", 0, item, serializer.fragment("link"))[1])
            end
        end
        for _, item in ipairs(highlight.signs) do
            table.insert(src, serializer.function_call("sign", item.sign, {
                text = item.text,
                culhl = "CursorLineSign",
                texthl = item.sign
            })[1])
        end
    end

    return table.concat(src, "\n")
end

local function create_theme(t)
    local hl = vim.api.nvim_set_hl
    local highlights = {}
    for k, v in pairs(t) do
        if type(v) == "table" and not v[1] then
            highlights[k] = v
        end
    end
    local function create_dependant(k, v)
        if type(v) == "string" then
            local parent = highlights[v]
            if not parent then
                parent = create_dependant(v, t[v])
            end
            highlights[k] = parent
            hl(0, k, v)
            return parent
        else
            local parent = highlights[v[1]]
            if not parent then
                parent = create_dependant(v[1], t[v[1]])
            end
            local opts = {
                fg = v.fg or parent.fg,
                bg = v.bg or parent.bg,
                attr = {
                    bold = v.bold or parent.attr.bold,
                    italic = v.italic or parent.attr.italic,
                    strikethrough = v.strikethrough or parent.attr.strikethrough,
                    underline = v.underline or parent.attr.underline,
                    undercurl = v.undercurl or parent.attr.undercurl,
                    reverse = v.reverse or parent.attr.reverse,
                }
            }
            hl(0, k, {
                ctermfg = opts.fg,
                ctermbg = opts.bg,
                cterm = opts.attr
            })
            highlights[k] = opts
            return opts
        end
    end
    for k, v in pairs(t) do
        if not highlights[k] then
            create_dependant(k, v)
        end
    end
end

create_theme({
    Constant = { fg = "cyan" },
    Literal = { fg = "darkyellow" },
    Number = "Literal",
    Character = "Literal",
    Boolean = "Literal",
    String = { fg = "darkgreen" },

    Identifier = {},
    Variable = "Identifier",
    Function = { fg = "darkblue" },

    Statement = { fg = "darkmagenta" },
    Conditional = "Statement",
    Repeat = "Statement",
    Label = "Statement",
    Operator = "Statement",
    Keyword = "Statement",
    Exception = { fg = "darkcyan" },

    PreProc = {},
    Define = { fg = "darkmagenta" },
    Macro = { fg = "darkmagenta" },
    PreCondit = { fg = "yellow"},
    Include = { fg = "darkblue" },

    Type = { fg = "yellow" },
    StorageClass = "Type",
    Structure = "Type",
    Typedef = {},

    Error = { fg = "darkred" },
    ErrorMsg = "Error",
    DiagnosticError = "ErrorMsg",
    DiagnosticErrorLine = { "DiagnosticError", bg = "GreyBg1" },
    DiagnosticUnderlineError = "DiagnosticError",
    DiagnosticSignError = { "DiagnosticError", sign = ">>" },

    Warning = { fg = "yellow" },
    WarningMsg = "Warning",
    DiagnosticWarn = "WarningMsg",
    DiagnosticWarnLine = { "DiagnosticWarn", bg = "GreyBg1" },
    DiagnosticUnderlineWarn = "DiagnosticWarn",
    DiagnosticSignWarn = { "DiagnosticWarn", sign =  ">>" },

    SpellBad = { "Error", undercurl = true },
    SpellCap = { "Warning", undercurl = true },

    Special = { fg = "darkmagenta" },
    SpecialKey = "Special",

    Title = { fg = "darkgreen" },
    Todo = "Special",
    Question = "Special",
    Comment = { "GreyFg2", italic = true },
    SpecialComment = "GreyFg2",
    SpecialChar = "GreyFg3",

    GreyBg1 = { bg = grey(1) },
    GreyBg2 = { bg = grey(2) },
    GreyBg3 = { bg = grey(3) },
    GreyBg4 = { bg = grey(5) },

    GreyFg1 = { fg = grey(4) },
    GreyFg2 = { fg = grey(6) },
    GreyFg3 = { fg = grey(12) },

    BgRed1 = { bg = rgb(1, 0, 0) },
    BgRed2 = { bg = rgb(2, 0, 0) },
    BgGreen1 = { bg = rgb(0, 1, 0) },
    BgGreen2 = { bg = rgb(0, 2, 0) },

    CursorLine = "GreyBg1",
    CursorLineNr = "CursorLine",
    CursorLineSign = "CursorLine",
    CursorLineFold = "CursorLine",
    CursorColumn = "CursorLine",

    Pmenu = "GreyBg2",
    PmenuSbar = "GreyBg2",
    PmenuThumb = "GreyBg3",
    PmenuSel = "GreyBg4",

    TabLine = "GreyBg2",
    TabLineSel = "GreyBg2",
    TabLineFill = "GreyBg2",

    StatusLine = "GreyBg2",
    StatusLineNC = "GreyFg2",

    NormalFloat = "GreyBg2",

    WildMenu = { bg = "darkblue" },

    Visual = "GreyBg3",
    Search = "GreyBg2",
    IncSearch = { "Search", fg = "yellow" },

    NonText = "GreyFg1",
    VertSplit = "GreyFg1",
    Border = "GreyFg1",
    LineNr = "GreyFg1",
    WinSeparator = "GreyFg1",

    Folded = "GreyFg2",
    CmpItemKindText = "GreyFg2",
    CmpItemMenu = "GreyFg2",

    DiagnosticUnnecessary = "GreyFg3",
    DiagnosticUnderlineHint = "GreyFg3",
    DiagnosticUnderlineInfo = "GreyFg3",
    CmpItemAbbrDeprecated = { "GreyFg3", strikethrough = true },

    DiffDelete = "BgRed1",
    DiffCharDelete = "BgRed2",
    DiffAdd = "BgGreen1",
    DiffCharAdd = "BgGreen2",
    DiffChange = {},

    ["@function.builtin"] = "Function",
    ["@variable.builtin"] = "Variable",
    ["@constant.builtin"] = "Constant",
    ["@type.builtin"] = "Type",
})


return generate_theme({
    "Normal",
    -- "@field",
    -- "@parameter",
    -- "@property",
    -- "@punctuation",
    -- "@variable",
    -- "@variable.builtin",
    "Identifier",
    -- "@constructor",
    -- "@type",
    "DiagnosticHint",
    "Underlined",
    "PreProc",
    "DiffChange",
    "Conceal",
    "ModeMsg",
    "SignColumn",
    "FoldColumn",
    reverse("Cursor"),
    bold("QuickFixLine"),
    red.fg(
        "Error",
        "DiagnosticError",
        "ErrorMsg",
        -- "@label",
        -- "@type.definition",
        -- "@tag",
        "DiagnosticUnderlineError",
        undercurl("SpellBad"),
        sign("DiagnosticSignError", ">>")
    ),
    green.fg(
        "String",
        "Character",
        -- "@string",
        bold("Title")
    ),
    blue.fg(
        "Function",
        "Include",
        "Directory",
        -- "@function",
        -- "@function.builtin",
        -- "@function.macro",
        -- "@method",
        "CmpItemKindMethod",
        "CmpItemKindFunction"
    ),
    blue.bg("WildMenu"),
    yellow.fg(
        "Number",
        "Float",
        "Boolean",
        -- "@boolean",
        -- "@character",
        -- "@float",
        -- "@number",
        -- "@constant.macro",
        "DiagnosticWarn",
        "DiagnosticUnderlineWarn",
        "DiffText",
        undercurl("SpellCap"),
        sign("DiagnosticSignWarn", ">>"),
        sign("DiagnosticSignHint", ">>"),
        sign("DiagnosticSignInfo", ">>")
    ),
    cyan.fg(
        "Constant",
        "Exception",
        -- "@constant",
        -- "@constant.builtin",
        "DiagnosticInfo",
        "CmpItemKindConstant"
    ),
    bright_yellow.fg(
        "Type",
        "PreCondit",
        "StorageClass",
        "Structure",
        -- "@type.builtin",
        -- "@type.qualifier",
        -- "@tag.attribute",
        "WarningMsg",
        "CmpItemKindInterface",
        "CmpItemKindClass",
        "CmpItemKindStruct"
    ),
    magenta.fg(
        "Keyword",
        "Todo",
        "Repeat",
        "Define",
        "Macro",
        "Statement",
        "Label",
        "Operator",
        "Special",
        "Question",
        "SpecialKey",
        -- "@conditional",
        -- "@exception",
        -- "@include",
        -- "@keyword",
        -- "@operator",
        -- "@repeat",
        "CmpItemKindVariable"
    ),
    magenta.bg("OperatorSandwichChange"),
    grey(1).bg(
        "CursorLine",
        "CursorLineNr",
        "CursorLineSign",
        "CursorLineFold",
        "CursorColumn",
        "BqfPreviewFloat",
        red.fg("DiagnosticErrorLine"),
        yellow.fg(
            "DiagnosticWarnLine",
            "DiagnosticHintLine",
            "DiagnosticInfoLine"
        )
    ),
    grey(2).bg(
        "Pmenu",
        "PmenuSbar",
        "StatusLine",
        "TabLine",
        "TabLineSel",
        "TabLineFill",
        "NormalFloat",
        "Search",
        yellow.fg(
            "IncSearch",
            "BqfPreviewRange",
            "CurSearch"
        ),
        magenta.fg("MatchParen"),
        grey(4).fg("FloatBorder")
    ),
    grey(3).bg(
        "Visual",
        "PmenuThumb",
        green.fg("BqfPreviewTitle")
    ),
    grey(4).fg(
        "NonText",
        "VertSplit",
        "Border",
        "LineNr",
        "BqfPreviewBorder",
        "WinSeparator"
    ),
    grey(5).bg("PmenuSel"),
    grey(6).fg(
        "Folded",
        "SpecialComment",
        "StatusLineNC",
        "CmpItemKindText",
        "CmpItemMenu",
        italic(
            "Comment"
            -- "@comment"
        )
    ),
    grey(12).fg(
        "SpecialChar",
        "DiagnosticUnnecessary",
        "DiagnosticUnderlineHint",
        "DiagnosticUnderlineInfo",
        strikethrough(
            "CmpItemAbbrDeprecated"
        )
    ),

    rgb(1, 0, 0).bg("DiffDelete"),
    rgb(2, 0, 0).bg("DiffCharDelete"),
    rgb(0, 1, 0).bg("DiffAdd"),
    rgb(0, 2, 0).bg("DiffCharAdd")
})
