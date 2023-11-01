-- gf and if it doesn't exist, create it
local function forceGoFile()
    local fname = vim.fn.expand("<cfile>")
    local path = vim.fn.expand("%:p:h") .. "/" .. fname
    if vim.fn.filereadable(path) ~= 1 then
        vim.cmd("silent! !touch " .. path)
    end
    vim.cmd.norm("gf")
end
vim.keymap.set("n", "<leader>gf", forceGoFile);

-- repeat <c-r> to use unnamed register analogous to ""
vim.keymap.set("i", "<c-r><c-r>", "<c-r>\"");

-- U makes more sense than <c-r> for redo
vim.keymap.set("n", "U", "<c-r>");

-- my <c-k> is mapped <up> in tmux
vim.keymap.set("i", "<up>", "<c-k>");

-- default <c-u> and <c-d> are disorientating
vim.keymap.set("n", "<c-u>", "10k");
vim.keymap.set("n", "<c-d>", "10j");

-- zero width space digraph
vim.cmd.digraph("zs " .. 0x200b)

-- toggle cursor column
vim.keymap.set("n", "<leader>cc", function()
    vim.o.cursorcolumn = not vim.o.cursorcolumn
end)

-- visually select pasted content
vim.keymap.set("n", "gp", function()
    return "`[" .. vim.fn.strpart(vim.fn.getregtype(), 0, 1) .. "`]"
end, {expr=true})

local function getPopups()
    return vim.fn.filter(vim.api.nvim_tabpage_list_wins(0),
        function(_, e) return vim.api.nvim_win_get_config(e).zindex end)
end

local function killPopups()
   vim.fn.map(getPopups(), function(_, e)
        vim.api.nvim_win_close(e, false)
    end)
end

vim.keymap.set("n", "<esc>", function()
    vim.cmd.noh()
    killPopups()
end)

-- ^, $, and %, <c-^> are motions I use all the time
-- however, the keys are in awful positions
vim.keymap.set({"n", "v", "o"}, "gh", "^")
vim.keymap.set({"n", "v", "o"}, "gl", "$")
vim.keymap.set({"n", "v", "o"}, "gm", "%")

vim.keymap.set("n", "H", "H^")
vim.keymap.set("n", "M", "M^")
vim.keymap.set("n", "L", "L^")

-- I center screen all the time, zz is slow and hurts my finger
vim.keymap.set({"n", "v"}, "gb", "zz")
vim.keymap.set("n", "<c-o>", "<c-o>zz")
vim.keymap.set("n", "<c-i>", "<c-i>zz")

-- fix spelling for cursor word
local function fixSpelling()
    local cword = vim.fn.expand("<cword>")
    local spelling = vim.fn.spellsuggest("_" .. cword)[1] or ""
    spelling = (cword:lower() == cword) and spelling:lower() or spelling
    local output = '"_yiw'
    if spelling:match("^[a-zA-Z -]+$") and cword ~= spelling then
        output = '"_ciw' .. spelling .. "\x1b" .. output
    end
    return output
end
vim.keymap.set("n", "<leader>s", fixSpelling, { expr = true })

-- dd, yy, cc, etc all take too long since the same key is pressed twice
-- use dl, yl, cl etc instead
vim.keymap.set("o", "l", "_")
vim.keymap.set("o", "L", "_")
vim.keymap.set("o", ".", "l")

-- y is one of the hardest keys to press yet yanking is very common
-- t is easier to press yet t is never used outside of operator pending mode
vim.keymap.set({"n", "v"}, "t", "y")
vim.keymap.set({"n", "v"}, "y", "<NOP>")

vim.keymap.set("n", "<leader>i", "~hi");
