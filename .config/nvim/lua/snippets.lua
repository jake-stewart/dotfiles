local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local SNIPPET_LEADER = "<c-f>"

local function snippet(key, output)
    vim.keymap.set("i", SNIPPET_LEADER .. key, output)
end

local function printLineSnippet(output) snippet("<down>", output) end
local function debugSnippet(output) snippet("<c-d>", output) end
local function errorSnippet(output) snippet("<c-x>", output) end
local function whileLoopSnippet(output) snippet("<c-w>", output) end
local function forLoopSnippet(output) snippet("<c-f>", output) end
local function ifStatementSnippet(output) snippet("<c-i>", output) end
local function elseIfStatementSnippet(output) snippet("<c-o>", output) end
local function elseStatementSnippet(output) snippet("<c-e>", output) end
local function switchSnippet(output) snippet("<c-s>", output) end
local function caseSnippet(output) snippet("<c-v>", output) end
local function defaultCaseSnippet(output) snippet("<c-b>", output) end
local function functionSnippet(output) snippet("<c-m>", output) end
local function lambdaSnippet(output) snippet("<c-l>", output) end
local function classSnippet(output) snippet("<c-k>", output) end
local function structSnippet(output) snippet("<c-h>", output) end
local function tryCatchSnippet(output) snippet("<c-t>", output) end

snippet("<c-p>", "()<left>")

augroup("PythonSnippets", { clear = true })
autocmd("FileType", {
    pattern = "python",
    group = "PythonSnippets",
    callback = function()
        snippet("-", "____<left><left>")
        printLineSnippet('print("")<left><left>')
        debugSnippet("print()<left>")
        errorSnippet("print()<left>")
        whileLoopSnippet("while :<left>")
        forLoopSnippet("for :<left>")
        ifStatementSnippet("if :<esc>i")
        elseIfStatementSnippet("elif :<left>")
        elseStatementSnippet("else:<CR>")
        functionSnippet("def ():<esc>Bi")
        lambdaSnippet("lambda:<left>")
        classSnippet("class :<left>")
        structSnippet("class :<left>")
        tryCatchSnippet("try:<CR>...<CR>except Exception as e:<CR>...<ESC>kkA<BS><BS><BS>")
    end,
})

augroup("ShellSnippets", { clear = true })
autocmd("FileType", {
    pattern = "bash,sh",
    group = "ShellSnippets",
    callback = function()
        printLineSnippet('echo<space>""<left>')
        debugSnippet("echo<space>")
        errorSnippet("echo  >/dev/stderr<ESC>Bhi")
        whileLoopSnippet("while ; do<CR>done<esc>k$hhhi")
        forLoopSnippet("for ; do<CR>done<esc>k$hhhi")
        ifStatementSnippet("if ; then<CR>fi<esc>k$bbi")
        elseIfStatementSnippet("elif ; then<esc>bbi")
        elseStatementSnippet("else<CR>")
        switchSnippet("case in<CR>esac<esc>k$bhi<space>")
        caseSnippet(")<CR>;;<esc>k$i")
        defaultCaseSnippet("*)<CR>;;<esc>O")
        functionSnippet("() {<CR>}<esc>k$F(i")
    end,
})

augroup("JavascriptSnippets", { clear = true })
autocmd("FileType", {
    pattern = "javascript,typescript,typescriptreact",
    group = "JavascriptSnippets",
    callback = function()
        printLineSnippet('console.log("");<esc>hhi')
        debugSnippet("console.log();<esc>hi")
        errorSnippet("console.error();<esc>hi")
        whileLoopSnippet("while () {<CR>}<esc>k$hhi")
        forLoopSnippet("for () {<CR>}<esc>k$hhi")
        ifStatementSnippet("if () {<CR>}<esc>k$hhi")
        elseIfStatementSnippet("else if () {<CR>}<esc>k$hhi")
        elseStatementSnippet("else {<CR>}<esc>O")
        switchSnippet("switch () {<CR>}<esc>k$hhi")
        caseSnippet('case tmp:<CR>break;<esc>k$B"_cw')
        defaultCaseSnippet("default:<CR>break;<esc>O")
        functionSnippet("function () {<CR>}<esc>k$F(i")
        lambdaSnippet("() => {<CR>}<esc>%F)i")
        classSnippet("class  {<CR>}<esc>k$hi")
        structSnippet("interface  {<CR>}<esc>k$hi")
        tryCatchSnippet("try {<CR>}<CR>catch (error) {<CR>}<ESC>kkO")
    end,
})

augroup("CSnippets", { clear = true })
autocmd("FileType", {
    pattern = "c",
    group = "CSnippets",
    callback = function()
        printLineSnippet('printf("\\n");<esc>hhhhi')
        debugSnippet("printf();<esc>hi")
        whileLoopSnippet("while () {<CR>}<esc>k$hhi")
        forLoopSnippet("for () {<CR>}<esc>k$hhi")
        ifStatementSnippet("if () {<CR>}<esc>k$hhi")
        elseIfStatementSnippet("else if () {<CR>}<esc>k$hhi")
        elseStatementSnippet("else {<CR>}<esc>O")
        switchSnippet("switch () {<CR>}<esc>k$hhi")
        caseSnippet('case tmp:<CR>break;<esc>k$B"_cw')
        defaultCaseSnippet("default:<CR>break;<esc>O")
        functionSnippet("() {<CR>}<esc>k$F(i")
        structSnippet("struct  {<CR>}<esc>k$hi")
        tryCatchSnippet("try {<CR>}<CR>catch {<CR>}<ESC>kkO")
    end,
})

augroup("CppSnippets", { clear = true })
autocmd("FileType", {
    pattern = "cpp",
    group = "CppSnippets",
    callback = function()
        printLineSnippet('printf("\\n");<esc>hhhhi')
        debugSnippet("printf();<esc>hi")
        whileLoopSnippet("while () {<CR>}<esc>k$hhi")
        forLoopSnippet("for () {<CR>}<esc>k$hhi")
        ifStatementSnippet("if () {<CR>}<esc>k$hhi")
        elseIfStatementSnippet("else if () {<CR>}<esc>k$hhi")
        elseStatementSnippet("else {<CR>}<esc>O")
        switchSnippet("switch () {<CR>}<esc>k$hhi")
        caseSnippet('case tmp:<CR>break;<esc>k$B"_cw')
        defaultCaseSnippet("default:<CR>break;<esc>O")
        functionSnippet("() {<CR>}<esc>k$F(i")
        lambdaSnippet("[]() {}<left><left><left><left>")
        classSnippet("class  {<CR>}<esc>k$hi")
        structSnippet("struct  {<CR>}<esc>k$hi")
        tryCatchSnippet("try {<CR>}<CR>catch {<CR>}<ESC>kkO")
    end,
})

augroup("JavaSnippets", { clear = true })
autocmd("FileType", {
    pattern = "java",
    group = "JavaSnippets",
    callback = function()
        printLineSnippet('system.out.println("");<esc>hhi')
        debugSnippet("system.out.println();<esc>hi")
        whileLoopSnippet("while () {<CR>}<esc>k$hhi")
        forLoopSnippet("for () {<CR>}<esc>k$hhi")
        ifStatementSnippet("if () {<CR>}<esc>k$hhi")
        elseIfStatementSnippet("else if () {<CR>}<esc>k$hhi")
        elseStatementSnippet("else {<CR>}<esc>O")
        switchSnippet("switch () {<CR>}<esc>k$hhi")
        caseSnippet('case tmp:<CR>break;<esc>k$B"_cw')
        defaultCaseSnippet("default:<CR>break;<esc>O")
        functionSnippet("() {<CR>}<esc>k$F(i")
        lambdaSnippet("() -> {}<esc>F)i")
        classSnippet("public class  {<CR>}<esc>k$hi")
        structSnippet("private class  {<CR>}<esc>k$hi")
        tryCatchSnippet("try {<CR>}<CR>catch {<CR>}<ESC>kkO")
    end,
})

augroup("CSharpSnippets", { clear = true })
autocmd("FileType", {
    pattern = "cs",
    group = "CSharpSnippets",
    callback = function()
        printLineSnippet('Debug.Log("");<esc>hhi')
        debugSnippet("Util.Log();<left><left>")
        whileLoopSnippet("while () {<CR>}<esc>k$hhi")
        forLoopSnippet("for () {<CR>}<esc>k$hhi")
        ifStatementSnippet("if () {<CR>}<esc>k$hhi")
        elseIfStatementSnippet("else if () {<CR>}<esc>k$hhi")
        elseStatementSnippet("else {<CR>}<esc>O")
        switchSnippet("switch () {<CR>}<esc>k$hhi")
        caseSnippet('case tmp:<CR>break;<esc>k$B"_cw')
        defaultCaseSnippet("default:<CR>break;<esc>O")
        functionSnippet("() {<CR>}<esc>k$F(i")
        lambdaSnippet("[]() {}<left><left><left><left>")
        classSnippet("class  {<CR>}<esc>k$hi")
        structSnippet("struct  {<CR>}<esc>k$hi")
        tryCatchSnippet("try {<CR>}<CR>catch {<CR>}<ESC>kkO")
    end,
})

augroup("LuaSnippets", { clear = true })
autocmd("FileType", {
    pattern = "lua",
    group = "LuaSnippets",
    callback = function()
        printLineSnippet('print("")<left><left>')
        debugSnippet("vim.print()<left>")
        whileLoopSnippet("while true do<CR>end<esc>k$BB\"_ciw")
        forLoopSnippet("for do<CR>end<esc>k$Bhi ")
        ifStatementSnippet("if true then<CR>end<esc>k$BB\"_ciw")
        elseIfStatementSnippet("elseif true then<esc>BB\"_ciw")
        elseStatementSnippet("else<CR>")
        functionSnippet("local function name()<CR>end<esc>k$F(\"_cb")
        lambdaSnippet("function()<CR>end<esc>O")
        tryCatchSnippet("pcall(function()<CR>end)<esc>O")
    end,
})
