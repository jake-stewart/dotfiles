"
" __     ___              ____      _                
" \ \   / (_)_ __ ___    / ___|___ | | ___  _ __ ___ 
"  \ \ / /| | '_ ` _ \  | |   / _ \| |/ _ \| '__/ __|
"   \ V / | | | | | | | | |__| (_) | | (_) | |  \__ \
"    \_/  |_|_| |_| |_|  \____\___/|_|\___/|_|  |___/
"

set notermguicolors

" COLOR PALETTE {{{

let s:bg     = "NONE"
let s:fg     = "NONE"

let s:white  = "white"
let s:cyan   = "darkcyan"
let s:orange = "darkyellow"
let s:red    = "darkred"
let s:green  = "darkgreen"
let s:yellow = "yellow"
let s:blue   = "darkblue"
let s:purple = "darkmagenta"

let s:grey_0 = "233"
let s:grey_1 = "234"
let s:grey_2 = "235"
let s:grey_3 = "236"
let s:grey_4 = "237"
let s:grey_5 = "238"

let s:warn    = "darkyellow"
let s:error   = "darkred"
let s:debug   = "201"

" }}}
" HL FUNCTION {{{

function! HL(name, fg, bg, attr)
    exe "hi " . a:name
                \ . " ctermfg=" . a:fg
                \ . " ctermbg=" . a:bg
                \ . " cterm=" . a:attr
endfunction

" }}}
" HL DEFINITION {{{

call HL("Normal",                   s:fg,     s:bg,     "NONE")
call HL("Conceal",                  s:fg,     "NONE",   "NONE")
call HL("Cursor",                   s:bg,     s:fg,     "NONE")
call HL("CursorLine",               "NONE",   s:grey_0, "NONE")
call HL("CursorColumn",             "NONE",   s:grey_0, "NONE")
call HL("SignColumn",               "NONE",   "NONE",   "NONE")
call HL("FoldColumn",               "NONE",   "NONE",   "NONE")
call HL("VertSplit",                s:grey_2, "NONE",   "NONE")
call HL("LineNr",                   s:grey_2, "NONE",   "NONE")
call HL("CursorLineNr",             "NONE",   s:grey_0, "NONE")
call HL("Folded",                   s:grey_5, "NONE",   "NONE")
call HL("IncSearch",                s:yellow, s:grey_1, "NONE")
call HL("Search",                   "NONE",   s:grey_1, "NONE")
call HL("ModeMsg",                  "NONE",   "NONE",   "NONE")
call HL("NonText",                  s:grey_2, "NONE",   "NONE")
call HL("Question",                 s:purple, "NONE",   "NONE")
call HL("SpecialKey",               s:debug,  "NONE",   "NONE")
call HL("StatusLine",               s:fg,     s:grey_1, "NONE")
call HL("StatusLineNC",             s:grey_5, s:grey_1, "NONE")
call HL("Title",                    s:green,  "NONE",   "BOLD")
call HL("Visual",                   "NONE",   s:grey_1, "NONE")
call HL("WarningMsg",               s:yellow, "NONE",   "NONE")
call HL("Pmenu",                    "NONE",   s:grey_1, "NONE")
call HL("PmenuSel",                 s:fg,     s:grey_3, "NONE")
call HL("PmenuThumb",               s:fg,     s:grey_2, "NONE")
call HL("PmenuSbar",                "NONE",   s:grey_1, "NONE")
call HL("CocMenu",                  s:fg,     "NONE",   "NONE")
call HL("CocMenuSel",               s:fg,     s:grey_3, "NONE")
call HL("CocFadeout",               s:grey_5, "NONE",   "NONE")
call HL("CocWarningSign",           s:warn,   "NONE",   "NONE")
call HL("DiffDelete",               s:red,    "NONE",   "NONE")
call HL("DiffAdd",                  s:green,  "NONE",   "NONE")
call HL("DiffChange",               s:yellow, "NONE",   "BOLD")
call HL("DiffText",                 s:bg,     s:fg,     "NONE")
call HL("Underlined",               "NONE",   "NONE",   "UNDERLINE")
call HL("OperatorSandwichChange",   "NONE",   s:debug,  "NONE")
call HL("Comment",                  s:grey_5, "NONE",   "ITALIC")
call HL("Exception",                s:cyan,   "NONE",   "NONE")
call HL("Constant",                 s:cyan,   "NONE",   "NONE")
call HL("Float",                    s:orange, "NONE",   "NONE")
call HL("Number",                   s:orange, "NONE",   "NONE")
call HL("Boolean",                  s:orange, "NONE",   "NONE")
call HL("Identifier",               s:red,    "NONE",   "NONE")
call HL("Keyword",                  s:red,    "NONE",   "NONE")
call HL("Error",                    s:error,  "NONE",   "NONE")
call HL("ErrorMsg",                 s:error,  "NONE",   "NONE")
call HL("String",                   s:green,  "NONE",   "NONE")
call HL("Character",                s:green,  "NONE",   "NONE")
call HL("PreProc",                  s:yellow, "NONE",   "NONE")
call HL("PreCondit",                s:yellow, "NONE",   "NONE")
call HL("StorageClass",             s:yellow, "NONE",   "NONE")
call HL("Structure",                s:yellow, "NONE",   "NONE")
call HL("Type",                     s:yellow, "NONE",   "NONE")
call HL("Special",                  s:blue,   "NONE",   "NONE")
call HL("WildMenu",                 s:bg,     s:blue,   "NONE")
call HL("Include",                  s:blue,   "NONE",   "NONE")
call HL("Function",                 s:blue,   "NONE",   "NONE")
call HL("Todo",                     s:purple, "NONE",   "NONE")
call HL("Repeat",                   s:purple, "NONE",   "NONE")
call HL("Define",                   s:purple, "NONE",   "NONE")
call HL("Macro",                    s:purple, "NONE",   "NONE")
call HL("Statement",                s:purple, "NONE",   "NONE")
call HL("Label",                    s:purple, "NONE",   "NONE")
call HL("Operator",                 s:purple, "NONE",   "NONE")
call HL("MatchParen",               s:purple, s:grey_1, "NONE")
call HL("TabLine",                  s:fg,     s:grey_1, "NONE")
call HL("TabLineFill",              "NONE",   s:grey_1, "NONE")
call HL("TabLineSel",               s:white,  s:grey_1, "NONE")
call HL("Directory",                s:blue,   "NONE",   "NONE")
call HL("TSAnnotation",             s:fg,     "NONE",   "NONE")
call HL("TSAttribute",              s:fg,     "NONE",   "NONE")
call HL("TSBoolean",                s:orange, "NONE",   "NONE")
call HL("TSCharacter",              s:orange, "NONE",   "NONE")
call HL("TSComment",                s:grey_5, "NONE",   "italic")
call HL("TSConditional",            s:purple, "NONE",   "NONE")
call HL("TSConstant",               s:cyan,   "NONE",   "NONE")
call HL("TSConstBuiltin",           s:cyan,   "NONE",   "NONE")
call HL("TSConstMacro",             s:orange, "NONE",   "NONE")
call HL("TSConstructor",            s:yellow, "NONE",   "NONE")
call HL("TSError",                  s:fg,     "NONE",   "NONE")
call HL("TSException",              s:purple, "NONE",   "NONE")
call HL("TSField",                  s:fg,     "NONE",   "NONE")
call HL("TSFloat",                  s:orange, "NONE",   "NONE")
call HL("TSFunction",               s:blue,   "NONE",   "NONE")
call HL("TSFuncBuiltin",            s:blue,   "NONE",   "NONE")
call HL("TSFuncMacro",              s:blue,   "NONE",   "NONE")
call HL("TSInclude",                s:purple, "NONE",   "NONE")
call HL("TSKeyword",                s:purple, "NONE",   "NONE")
call HL("TSKeywordFunction",        s:purple, "NONE",   "NONE")
call HL("TSKeywordOperator",        s:purple, "NONE",   "NONE")
call HL("TSLabel",                  s:red,    "NONE",   "NONE")
call HL("TSMethod",                 s:blue,   "NONE",   "NONE")
call HL("TSNamespace",              s:yellow, "NONE",   "NONE")
call HL("TSNone",                   s:fg,     "NONE",   "NONE")
call HL("TSNumber",                 s:orange, "NONE",   "NONE")
call HL("TSOperator",               s:fg,     "NONE",   "NONE")
call HL("TSParameter",              s:fg,     "NONE",   "NONE")
call HL("TSParameterReference",     s:fg,     "NONE",   "NONE")
call HL("TSProperty",               s:cyan,   "NONE",   "NONE")
call HL("TSPunctDelimiter",         s:fg,     "NONE",   "NONE")
call HL("TSPunctBracket",           s:fg,     "NONE",   "NONE")
call HL("TSPunctSpecial",           s:red,    "NONE",   "NONE")
call HL("TSRepeat",                 s:purple, "NONE",   "NONE")
call HL("TSString",                 s:green,  "NONE",   "NONE")
call HL("TSStringRegex",            s:orange, "NONE",   "NONE")
call HL("TSStringEscape",           s:red,    "NONE",   "NONE")
call HL("TSSymbol",                 s:cyan,   "NONE",   "NONE")
call HL("TSTag",                    s:red,    "NONE",   "NONE")
call HL("TSTagDelimiter",           s:red,    "NONE",   "NONE")
call HL("TSText",                   s:fg,     "NONE",   "NONE")
call HL("TSStrong",                 s:fg,     "NONE",   "bold")
call HL("TSEmphasis",               s:fg,     "NONE",   "italic")
call HL("TSUnderline",              s:fg,     "NONE",   "underline")
call HL("TSStrike",                 s:fg,     "NONE",   "strikethrough")
call HL("TSTitle",                  s:orange, "NONE",   "bold")
call HL("TSLiteral",                s:green,  "NONE",   "NONE")
call HL("TSURI",                    s:cyan,   "NONE",   "underline")
call HL("TSMath",                   s:fg,     "NONE",   "NONE")
call HL("TSTextReference",          s:blue,   "NONE",   "NONE")
call HL("TSEnviroment",             s:fg,     "NONE",   "NONE")
call HL("TSEnviromentName",         s:fg,     "NONE",   "NONE")
call HL("TSNote",                   s:fg,     "NONE",   "NONE")
call HL("TSWarning",                s:fg,     "NONE",   "NONE")
call HL("TSDanger",                 s:fg,     "NONE",   "NONE")
call HL("TSType",                   s:red,    "NONE",   "NONE")
call HL("TSTypeBuiltin",            s:orange, "NONE",   "NONE")
call HL("TSVariable",               s:fg,     "NONE",   "NONE")
call HL("TSVariableBuiltin",        s:red,    "NONE",   "NONE")
call HL("DiagnosticError",          s:error,  "NONE",   "NONE")
call HL("DiagnosticHint",           s:grey_5, "NONE",   "NONE")
call HL("DiagnosticInfo",           s:grey_5, "NONE",   "NONE")
call HL("DiagnosticWarn",           s:warn,   "NONE",   "NONE")
call HL("DiagnosticUnderlineError", s:error,  "NONE",   "underline")
call HL("DiagnosticUnderlineHint",  s:grey_5, "NONE",   "underline")
call HL("DiagnosticUnderlineInfo",  s:grey_5, "NONE",   "underline")
call HL("DiagnosticUnderlineWarn",  s:warn,   "NONE",   "underline")
call HL("Border",                   s:grey_2, "NONE",   "NONE")

" exe "hi SpellCap gui=UNDERCURL guisp=" . s:yellow
" exe "hi SpellBad gui=UNDERCURL guisp=" . s:red
exe "hi SpellCap gui=UNDERCURL guifg=" . s:yellow
exe "hi SpellBad gui=UNDERCURL guifg=" . s:red

hi default link BqfPreviewBorder Border
hi default link BqfPreviewFloat  Normal
hi default link BqfPreviewCursor Cursor
hi default link BqfPreviewRange  IncSearch

" }}}
" TERMINAL HIGHLIGHTING {{{

let g:terminal_color_0  = s:grey_5
let g:terminal_color_1  = s:red
let g:terminal_color_2  = s:green
let g:terminal_color_3  = s:yellow
let g:terminal_color_4  = s:blue
let g:terminal_color_5  = s:purple
let g:terminal_color_6  = s:cyan
let g:terminal_color_7  = s:white
let g:terminal_color_8  = s:grey_5
let g:terminal_color_9  = s:red
let g:terminal_color_10 = s:green
let g:terminal_color_11 = s:yellow
let g:terminal_color_12 = s:blue
let g:terminal_color_13 = s:purple
let g:terminal_color_14 = s:cyan
let g:terminal_color_15 = s:white

" }}}
" VISUAL CURSORLINE {{{

" in vim, the cursorline disappears when in visual mdoe
" however, the cursorline in the number column remains
" this function + autocommands removes cusorline from
" the number column when in visual mode

function RemoveCursorlineInVisual()
    if mode() =~# "^[vV\x16]"
        set showcmd
        exe "hi CursorLineNr ctermbg=" . s:bg
    else
        set noshowcmd
        exe "hi CursorLineNr ctermbg=" . s:grey_0
    endif
endfunction

if !exists("cul_au_loaded")
    let cul_au_loaded = 1
    au ModeChanged [vV\x16]*:* call RemoveCursorlineInVisual()
    au ModeChanged *:[vV\x16]* call RemoveCursorlineInVisual()
    au WinEnter,WinLeave *     call RemoveCursorlineInVisual()
endif

" }}}

" vim:nowrap:foldmethod=marker
