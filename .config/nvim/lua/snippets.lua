local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local SNIPPET_GROUP = "Snippets"
local SNIPPET_LEADER = "<c-f>"


function snippet(key, output)
    vim.keymap.set("i", SNIPPET_LEADER .. key, output)
end
function printLineSnippet(output) snippet("<c-j>", output) end
function debugSnippet(output) snippet("<c-d>", output) end
function whileLoopSnippet(output) snippet("<c-w>", output) end
function forLoopSnippet(output) snippet("<c-f>", output) end
function ifStatementSnippet(output) snippet("<c-i>", output) end
function elseIfStatementSnippet(output) snippet("<c-o>", output) end
function elseStatementSnippet(output) snippet("<c-e>", output) end
function switchSnippet(output) snippet("<c-s>", output) end
function caseSnippet(output) snippet("<c-v>", output) end
function defaultCaseSnippet(output) snippet("<c-b>", output) end
function functionSnippet(output) snippet("<c-m>", output) end
function lambdaSnippet(output) snippet("<c-l>", output) end
function classSnippet(output) snippet("<c-k>", output) end
function structSnippet(output) snippet("<c-t>", output) end

augroup("PythonSnippets", {clear=true})
autocmd("FileType", {
    pattern = "python",
    group = "PythonSnippets",
    callback = function()
        snippet("-", "____<left><left>")
        printLineSnippet('print("")<left><left>')
        debugSnippet('print()<left>')
        whileLoopSnippet('while :<left>')
        forLoopSnippet("for :<left>")
        ifStatementSnippet("if :<esc>i")
        elseIfStatementSnippet("elif :<left>")
        elseStatementSnippet("else:<CR>")
        functionSnippet("def ():<esc>Bi")
        lambdaSnippet("lambda:<left>")
        classSnippet("class :<left>")
        structSnippet("class :<left>")
    end
})

augroup("ShellSnippets", {clear=true})
autocmd("FileType", {
    pattern = "bash,sh",
    group = "ShellSnippets",
    callback = function()
        printLineSnippet('echo<space>""<left>')
        debugSnippet('echo<space>')
        whileLoopSnippet('while ; do<CR>done<esc>k$hhhi')
        forLoopSnippet("for ; do<CR>done<esc>k$hhhi")
        ifStatementSnippet("if ; then<CR>fi<esc>k$bbi")
        elseIfStatementSnippet("elif ; then<esc>bbi")
        elseStatementSnippet("else<CR>")
        switchSnippet("case in<CR>esac<esc>k$bhi<space>")
        caseSnippet(")<CR>;;<esc>k$i")
        defaultCaseSnippet("*)<CR>;;<esc>O")
        functionSnippet("() {<CR>}<esc>k$F(i")
    end
})

augroup("JavascriptSnippets", {clear=true})
autocmd("FileType", {
    pattern = "javascript,typescript,typescriptreact",
    group = "JavascriptSnippets",
    callback = function()
        printLineSnippet('console.log("");<esc>hhi')
        debugSnippet('console.log();<esc>hi')
        whileLoopSnippet('while () {<CR>}<esc>k$hhi')
        forLoopSnippet("for () {<CR>}<esc>k$hhi")
        ifStatementSnippet("if () {<CR>}<esc>k$hhi")
        elseIfStatementSnippet("else if () {<CR>}<esc>k$hhi")
        elseStatementSnippet("else {<CR>}<esc>O")
        switchSnippet("switch () {<CR>}<esc>k$hhi")
        caseSnippet("case tmp:<CR>break;<esc>k$B\"_cw")
        defaultCaseSnippet("default:<CR>break;<esc>O")
        functionSnippet("function () {<CR>}<esc>k$F(i")
        lambdaSnippet("() => {<CR>}<esc>k$BBa")
        classSnippet("class  {<CR>}<esc>k$hi")
        structSnippet("struct  {<CR>}<esc>k$hi")
    end
})

augroup("CSnippets", {clear=true})
autocmd("FileType", {
    pattern = "c",
    group = "CSnippets",
    callback = function()
        printLineSnippet('printf("\\n");<esc>hhhhi')
        debugSnippet('printf();<esc>hi')
        whileLoopSnippet('while () {<CR>}<esc>k$hhi')
        forLoopSnippet("for () {<CR>}<esc>k$hhi")
        ifStatementSnippet("if () {<CR>}<esc>k$hhi")
        elseIfStatementSnippet("else if () {<CR>}<esc>k$hhi")
        elseStatementSnippet("else {<CR>}<esc>O")
        switchSnippet("switch () {<CR>}<esc>k$hhi")
        caseSnippet("case tmp:<CR>break;<esc>k$B\"_cw")
        defaultCaseSnippet("default:<CR>break;<esc>O")
        functionSnippet("() {<CR>}<esc>k$F(i")
        structSnippet("struct  {<CR>}<esc>k$hi")
    end
})

augroup("CppSnippets", {clear=true})
autocmd("FileType", {
    pattern = "cpp",
    group = "CppSnippets",
    callback = function()
        printLineSnippet('printf("\\n");<esc>hhhhi')
        debugSnippet('printf();<esc>hi')
        whileLoopSnippet('while () {<CR>}<esc>k$hhi')
        forLoopSnippet("for () {<CR>}<esc>k$hhi")
        ifStatementSnippet("if () {<CR>}<esc>k$hhi")
        elseIfStatementSnippet("else if () {<CR>}<esc>k$hhi")
        elseStatementSnippet("else {<CR>}<esc>O")
        switchSnippet("switch () {<CR>}<esc>k$hhi")
        caseSnippet("case tmp:<CR>break;<esc>k$B\"_cw")
        defaultCaseSnippet("default:<CR>break;<esc>O")
        functionSnippet("() {<CR>}<esc>k$F(i")
        lambdaSnippet("[]() {}<left><left><left><left>")
        classSnippet("class  {<CR>}<esc>k$hi")
        structSnippet("struct  {<CR>}<esc>k$hi")
    end
})

augroup("JavaSnippets", {clear=true})
autocmd("FileType", {
    pattern = "java",
    group = "CSnippets",
    callback = function()
        printLineSnippet('system.out.println("");<esc>hhi')
        debugSnippet('system.out.println();<esc>hi')
        whileLoopSnippet('while () {<CR>}<esc>k$hhi')
        forLoopSnippet("for () {<CR>}<esc>k$hhi")
        ifStatementSnippet("if () {<CR>}<esc>k$hhi")
        elseIfStatementSnippet("else if () {<CR>}<esc>k$hhi")
        elseStatementSnippet("else {<CR>}<esc>O")
        switchSnippet("switch () {<CR>}<esc>k$hhi")
        caseSnippet("case tmp:<CR>break;<esc>k$B\"_cw")
        defaultCaseSnippet("default:<CR>break;<esc>O")
        functionSnippet("() {<CR>}<esc>k$F(i")
        lambdaSnippet("() -> {}<esc>F)i")
        classSnippet("public class  {<CR>}<esc>k$hi")
        structSnippet("private class  {<CR>}<esc>k$hi")
    end
})

augroup("CSharpSnippets", {clear=true})
autocmd("FileType", {
    pattern = "cs",
    group = "CSharpSnippets",
    callback = function()
        printLineSnippet('Debug.Log("");<esc>hhi')
        debugSnippet('Util.Log();<left><left>')
        whileLoopSnippet('while () {<CR>}<esc>k$hhi')
        forLoopSnippet("for () {<CR>}<esc>k$hhi")
        ifStatementSnippet("if () {<CR>}<esc>k$hhi")
        elseIfStatementSnippet("else if () {<CR>}<esc>k$hhi")
        elseStatementSnippet("else {<CR>}<esc>O")
        switchSnippet("switch () {<CR>}<esc>k$hhi")
        caseSnippet("case tmp:<CR>break;<esc>k$B\"_cw")
        defaultCaseSnippet("default:<CR>break;<esc>O")
        functionSnippet("() {<CR>}<esc>k$F(i")
        lambdaSnippet("[]() {}<left><left><left><left>")
        classSnippet("class  {<CR>}<esc>k$hi")
        structSnippet("struct  {<CR>}<esc>k$hi")
    end
})
