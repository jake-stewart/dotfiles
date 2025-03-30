-- ┌─╮╭─╴╭─╮╶╮╷╶┬╴╭┬╮   ╭─╮╭─╮╷  ╭─╮┌─╮╭─╮
-- │ │├─ │ │ ││ │ │││   │  │ ││  │ │├┬╯╰─╮
-- ╵ ╵╰─╴╰─╯ ╰╯╶┴╴╵ ╵   ╰─╯╰─╯╰─╴╰─╯╵╰╴╰─╯

local augroup = require("config.util.augroup")

vim.o.termguicolors = false
vim.g.colors_name = "custom"

-- COLOR PALETTE {{{

local bg     = "NONE"
local fg     = "NONE"

local white  = 231
local bright = "white"
local cyan   = "darkcyan"
local orange = "darkyellow"
local red    = "darkred"
local green  = "darkgreen"
local yellow = "yellow"
local blue   = "darkblue"
local purple = "darkmagenta"
local grey   = "gray"

local grey0 = 232
local grey1 = 233
local grey2 = 234
local grey3 = 235
local grey4 = 236
local grey5 = 237
local grey6 = 238
local grey7 = 240

local BOLD = { bold = true }
local ITALIC = { italic = true }
local UNDERLINE = { underline = true }
local UNDERCURL = { undercurl = true }
local STRIKE = { strikethrough = true }
local REVERSE = { reverse = true }

-- }}}
-- HL FUNCTION {{{

local function HL(name, fgColor, bgColor, attr)
    vim.api.nvim_set_hl(0, name, {
        ctermfg = fgColor,
        ctermbg = bgColor,
        cterm = attr,
    })
end

local function LINK(name, to)
    vim.api.nvim_set_hl(0, name, {
        link = to
    })
end

function SIGN(name, text, hl)
    vim.fn.sign_define(name, {
        text = text,
        culhl = "CursorLineSign",
        texthl = hl
    })
end

-- }}}
-- HL DEFINITION {{{

HL("Normal",                   fg,        bg,       nil)
HL("Conceal",                  fg,        nil,      nil)
HL("Cursor",                   nil,       nil,      REVERSE)
HL("SignColumn",               nil,       nil,      nil)
HL("FoldColumn",               nil,       nil,      nil)
HL("VertSplit",                grey3,     nil,      nil)
HL("LineNr",                   grey3,     nil,      nil)
-- HL("FeintLine",                nil,       grey2,    nil)
HL("CursorColumn",             nil,       grey1,    nil)
HL("CursorLine",               nil,       grey1,    nil)
HL("CursorLineNr",             nil,       grey1,    nil)
HL("CursorLineSign",           nil,       grey1,    nil)
HL("CursorLineFold",           nil,       grey1,    nil)
HL("Folded",                   grey6,     nil,      nil)
HL("IncSearch",                yellow,    grey2,    nil)
HL("CurSearch",                yellow,    grey2,    nil)
HL("Search",                   nil,       grey2,    nil)
HL("ModeMsg",                  nil,       nil,      nil)
HL("NonText",                  grey3,     nil,      nil)
HL("Question",                 purple,    nil,      nil)
HL("SpecialKey",               purple,    nil,      nil)
HL("StatusLine",               fg,        grey2,    nil)
HL("StatusLineNC",             grey6,     grey2,    nil)
HL("Title",                    green,     nil,      BOLD)
HL("Visual",                   nil,       grey3,    nil)
HL("WarningMsg",               yellow,    nil,      nil)
HL("Pmenu",                    nil,       grey2,    nil)
HL("PmenuSel",                 fg,        grey4,    nil)
HL("PmenuThumb",               fg,        grey3,    nil)
HL("PmenuSbar",                nil,       grey2,    nil)
HL("CocMenu",                  fg,        nil,      nil)
HL("CocMenuSel",               fg,        grey4,    nil)
HL("CocFadeout",               grey6,     nil,      nil)
HL("CocWarningSign",           orange,    nil,      nil)
HL("DiffDelete",               red,       nil,      nil)
HL("DiffAdd",                  green,     nil,      nil)
HL("DiffChange",               yellow,    nil,      BOLD)
HL("DiffText",                 bg,        fg,       nil)
HL("Underlined",               nil,       nil,      UNDERLINE)
HL("OperatorSandwichChange",   nil,       purple,   nil)
HL("Comment",                  grey6,     nil,      ITALIC)
HL("SpecialComment",           grey7,     nil,      nil)
HL("Exception",                cyan,      nil,      nil)
HL("Constant",                 cyan,      nil,      nil)
HL("Float",                    orange,    nil,      nil)
HL("Number",                   orange,    nil,      nil)
HL("Boolean",                  orange,    nil,      nil)
HL("Identifier",               nil,       nil,      nil)
HL("Keyword",                  purple,    nil,      nil)
HL("Error",                    red,       nil,      nil)
HL("ErrorMsg",                 red,       nil,      nil)
HL("String",                   green,     nil,      nil)
HL("Character",                green,     nil,      nil)
HL("PreProc",                  yellow,    nil,      nil)
HL("PreCondit",                yellow,    nil,      nil)
HL("StorageClass",             yellow,    nil,      nil)
HL("Structure",                yellow,    nil,      nil)
HL("Type",                     yellow,    nil,      nil)
HL("Special",                  blue,      nil,      nil)
HL("WildMenu",                 bg,        blue,     nil)
HL("Include",                  blue,      nil,      nil)
HL("Function",                 blue,      nil,      nil)
HL("Todo",                     purple,    nil,      nil)
HL("Repeat",                   purple,    nil,      nil)
HL("Define",                   purple,    nil,      nil)
HL("Macro",                    purple,    nil,      nil)
HL("Statement",                purple,    nil,      nil)
HL("Label",                    purple,    nil,      nil)
HL("Operator",                 purple,    nil,      nil)
HL("MatchParen",               purple,    grey2,    nil)
HL("TabLine",                  fg,        grey2,    nil)
HL("TabLineFill",              nil,       grey2,    nil)
HL("TabLineSel",               bright,    grey2,    nil)
HL("Directory",                blue,      nil,      nil)
HL("@boolean",                 orange,    nil,      nil)
HL("@character",               orange,    nil,      nil)
HL("@comment",                 grey6,     nil,      ITALIC)
HL("@conditional",             purple,    nil,      nil)
HL("@constant",                cyan,      nil,      nil)
HL("@constant.builtin",        cyan,      nil,      nil)
HL("@constant.macro",          orange,    nil,      nil)
HL("@constructor",             nil,       nil,      nil)
HL("@exception",               purple,    nil,      nil)
HL("@field",                   white,     nil,      nil)
HL("@float",                   orange,    nil,      nil)
HL("@function",                blue,      nil,      nil)
HL("@function.builtin",        blue,      nil,      nil)
HL("@function.macro",          blue,      nil,      nil)
HL("@include",                 purple,    nil,      nil)
HL("@keyword",                 purple,    nil,      nil)
HL("@label",                   red,       nil,      nil)
HL("@method",                  blue,      nil,      nil)
HL("@number",                  orange,    nil,      nil)
HL("@operator",                purple,    nil,      nil)
HL("@parameter",               white,     nil,      nil)
HL("@property",                white,     nil,      nil)
HL("@punctuation",             white,     nil,      nil)
HL("@repeat",                  purple,    nil,      nil)
HL("@string",                  green,     nil,      nil)
HL("@string.escape",           grey7,     nil,      nil)
HL("@type",                    nil,       nil,      nil)
HL("@type.builtin",            yellow,    nil,      nil)
HL("@type.qualifier",          yellow,    nil,      nil)
HL("@type.definition",         red,       nil,      nil)
HL("@variable",                white,     nil,      nil)
HL("@variable.builtin",        white,     nil,      nil)
HL("@tag",                     red,       nil,      nil)
HL("@tag.delimiter",           grey7,     nil,      nil)
HL("@tag.attribute",           yellow,    nil,      nil)
HL("DiagnosticErrorLine",      red,       grey1,    nil)
HL("DiagnosticWarnLine",       orange,    grey1,    nil)
HL("DiagnosticHintLine",       orange,    grey1,    nil)
HL("DiagnosticInfoLine",       orange,    grey1,    nil)
HL("DiagnosticSignError",      red,       nil,      nil)
HL("DiagnosticSignWarn",       orange,    nil,      nil)
HL("DiagnosticSignHint",       orange,    nil,      nil)
HL("DiagnosticSignInfo",       orange,    nil,      nil)
HL("DiagnosticError",          nil,       nil,      nil)
HL("DiagnosticWarn",           orange,    nil,      nil)
HL("DiagnosticHint",           nil,       nil,      nil)
HL("DiagnosticInfo",           cyan,      nil,      nil)
HL("DiagnosticUnnecessary",    grey7,     nil,      nil)
HL("DiagnosticUnderlineError", red,       nil,      nil)
HL("DiagnosticUnderlineHint",  grey6,     nil,      nil)
HL("DiagnosticUnderlineInfo",  grey6,     nil,      nil)
HL("DiagnosticUnderlineWarn",  orange,    nil,      nil)
HL("Border",                   grey4,     nil,      nil)
HL("NormalFloat",              nil,       grey2,    nil)
HL("FloatBorder",              grey4,     grey2,    nil)
HL("WinSeparator",             grey4,     nil,      nil)
HL("CmpItemAbbrDeprecated",    grey6,     nil,      STRIKE)
HL("CmpItemKindText",          grey6,     nil,      nil)
HL("CmpItemKindMethod",        blue,      nil,      nil)
HL("CmpItemKindFunction",      blue,      nil,      nil)
HL("CmpItemKindInterface",     yellow,    nil,      nil)
HL("CmpItemKindClass",         yellow,    nil,      nil)
HL("CmpItemKindStruct",        yellow,    nil,      nil)
HL("CmpItemKindConstant",      cyan,      nil,      nil)
HL("CmpItemKindVariable",      purple,    nil,      nil)
HL("CmpItemMenu",              grey6,     nil,      nil)
HL("SpellCap",                 orange,    nil,      UNDERCURL)
HL("SpellBad",                 red,       nil,      UNDERCURL)

HL("BqfPreviewTitle",          green,     grey3,    nil)
HL("BqfPreviewFloat",          nil,       grey0,    nil)
HL("QuickFixLine",             nil,       nil,      BOLD)
LINK("BqfPreviewBorder", "Border")
LINK("BqfPreviewRange",  "IncSearch")


-- }}}
-- TERMINAL HIGHLIGHTING {{{

vim.g.terminal_color_0  = grey6
vim.g.terminal_color_1  = red
vim.g.terminal_color_2  = green
vim.g.terminal_color_3  = yellow
vim.g.terminal_color_4  = blue
vim.g.terminal_color_5  = purple
vim.g.terminal_color_6  = cyan
vim.g.terminal_color_7  = white
vim.g.terminal_color_8  = grey6
vim.g.terminal_color_9  = red
vim.g.terminal_color_10 = green
vim.g.terminal_color_11 = yellow
vim.g.terminal_color_12 = blue
vim.g.terminal_color_13 = purple
vim.g.terminal_color_14 = cyan
vim.g.terminal_color_15 = white

-- }}}
-- VISUAL CURSORLINE {{{

-- in vim, the cursorline disappears when in visual mode
-- however, the cursorline in the number column remains.
-- this autocommand toggles cursorline when in visual mode.
augroup("ColorschemeAutocommands")
    :au({
        event = "ModeChanged",
        callback = function()
            local mode = vim.fn.mode()
            local inVisualMode = mode == "v"
                or mode == "V"
                or mode == "\x16"
                or mode == "s"
                or mode == "S"
                or mode == "\x13"
            vim.o.cursorline = not inVisualMode
        end
    })

SIGN("DiagnosticSignError", ">>", "DiagnosticError")
SIGN("DiagnosticSignWarn", ">>", "DiagnosticWarn")
SIGN("DiagnosticSignInfo", ">>", "DiagnosticInfo")
SIGN("DiagnosticSignHint", ">>", "DiagnosticHint")


-- }}}

-- vim:nowrap:foldmethod=marker
