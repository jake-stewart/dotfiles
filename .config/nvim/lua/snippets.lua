local SNIPPET_LEADER = "<c-f>"

local function snippet(key, output, opts)
    vim.keymap.set("i", SNIPPET_LEADER .. key, output, opts)
end

local function bufferSnippet(key, output)
    snippet(key, output, {buffer = true})
end

-- global snippets
snippet("<c-p>", "()<left>")

-- filetype snippets
local function ftSnippet(key)
    return function(output)
        bufferSnippet(key, output)
    end
end

local printLineSnippet       = ftSnippet("<down>")
local debugSnippet           = ftSnippet("<c-d>")
local errorSnippet           = ftSnippet("<c-x>")
local whileLoopSnippet       = ftSnippet("<c-w>")
local forLoopSnippet         = ftSnippet("<c-f>")
local ifStatementSnippet     = ftSnippet("<c-i>")
local elseIfStatementSnippet = ftSnippet("<c-o>")
local elseStatementSnippet   = ftSnippet("<c-e>")
local switchSnippet          = ftSnippet("<c-s>")
local caseSnippet            = ftSnippet("<c-v>")
local defaultCaseSnippet     = ftSnippet("<c-b>")
local functionSnippet        = ftSnippet("<c-m>")
local lambdaSnippet          = ftSnippet("<c-l>")
local classSnippet           = ftSnippet("<c-k>")
local structSnippet          = ftSnippet("<c-h>")
local tryCatchSnippet        = ftSnippet("<c-t>")
local enumSnippet            = ftSnippet("<c-n>")

vim.api.nvim_create_augroup("FiletypeSnippets", { clear = true })
local function addFtSnippets(ft, callback)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        group = "FiletypeSnippets",
        callback = callback,
    })
end

addFtSnippets("python", function()
    bufferSnippet("-", "____<left><left>")
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
end)

addFtSnippets("bash,sh", function()
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
end)

addFtSnippets("javascript,typescript,typescriptreact", function()
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
end)

addFtSnippets("c", function()
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
end)

addFtSnippets("cpp", function()
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
end)

addFtSnippets("java", function()
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
end)

addFtSnippets("cs", function()
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
end)

addFtSnippets("lua", function()
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
end)

addFtSnippets("rust", function()
    printLineSnippet('println!("");<esc>$F"i')
    debugSnippet("dbg!(&);<esc>hi")
    whileLoopSnippet("while  {<CR>}<esc>k$hi")
    forLoopSnippet("for  {<CR>}<esc>k$hi")
    ifStatementSnippet("if  {<CR>}<esc>k$hi")
    elseIfStatementSnippet("else if  {<CR>}<esc>k$hi")
    elseStatementSnippet("else {<CR>}<esc>O")
    switchSnippet("match  {<CR>}<esc>k$hi")
    enumSnippet("enum  {<CR>}<esc>k$hi")
    structSnippet("struct  {<CR>}<esc>k$hi")
    functionSnippet("fn () {<CR>}<esc>k$F(i")
end)

addFtSnippets("go", function()
    printLineSnippet('fmt.Println("")<esc>hi')
    debugSnippet("fmt.Println()<esc>i")
    whileLoopSnippet("for  {<CR>}<esc>k$hi")
    forLoopSnippet("for  {<CR>}<esc>k$hi")
    ifStatementSnippet("if  {<CR>}<esc>k$hi")
    elseIfStatementSnippet("else if  {<CR>}<esc>k$hi")
    elseStatementSnippet("else {<CR>}<esc>O")
    switchSnippet("switch  {<CR>}<esc>k$hi")
    caseSnippet("case :<CR>fallthrough<esc>k$i")
    defaultCaseSnippet("default:<esc>O")
    functionSnippet("func () {<CR>}<esc>k$F(i")
    structSnippet("type  struct {<CR>}<esc>k$bhi")
end)
