local fn = vim.fn
local cmd = vim.cmd
local diagnostic = vim.diagnostic
local keymap = vim.keymap
local o = vim.o

local function forceGoFile()
    local fname = fn.expand("<cfile>")
    local path = fn.expand("%:p:h") .. "/" .. fname
    if fn.filereadable(path) ~= 1 then
        cmd("silent! !touch " .. path)
    end
    cmd.norm("gf")
end

keymap.set("n", "<space>", "<NOP>");

keymap.set("n", "<leader>gf", forceGoFile);

local function scroll(direction)
    local scrolloff = o.scrolloff
    o.scrolloff = 999
    cmd.norm("10" .. direction)
    o.scrolloff = scrolloff
end

keymap.set("n", "<c-u>", function() scroll("k") end);
keymap.set("n", "<c-d>", function() scroll("j") end);

-- zero width space digraph
cmd.digraph("zs " .. 0x200b)

-- toggle 80 char guide
keymap.set("n", "<leader>cc", function()
    o.cursorcolumn = not o.cursorcolumn
end)

-- toggle color column
keymap.set("n", "<leader>8", function()
    o.cc = o.cc == "80" and "0" or "80"
end)

-- visually select pasted content
keymap.set("n", "gp", function()
    return "`[" .. fn.strpart(fn.getregtype(), 0, 1) .. "`]"
end, {expr=true})

-- clear search highlight
keymap.set("n", "<esc>", function()
    vim.cmd.noh()
end)

-- ^, $, and %, <c-^> are motions I use all the time
-- however, the keys are in awful positions
keymap.set({"n", "v"}, "gh", "^")
keymap.set({"n", "v"}, "gl", "$")
keymap.set({"n", "v"}, "gm", "%")

keymap.set("n", "H", "H^")
keymap.set("n", "M", "M^")
keymap.set("n", "L", "L^")

-- I center screen all the time, zz is slow and hurts my finger
keymap.set("n", "gb", "zz")
keymap.set("n", "<c-o>", "<c-o>zz")
keymap.set("n", "<c-i>", "<c-i>zz")

keymap.set("n", "<leader>s", "1z=")

-- dd, yy, cc, etc all take too long since the same key is pressed twice
-- use dl, yl, cl etc instead
keymap.set("o", "l", "_")
keymap.set("o", "c", "l")

-- make l open fold even if at EOL
-- keymap.set("n", "l", function()
--     if fn.foldclosed(fn.line(".")) == -1 then
--         fn.feedkeys("l", "n")
--     else
--         cmd.foldopen()
--     end
-- end)

-- make h close fold if at SOL
-- keymap.set("n", "h", function()
--     if fn.foldlevel(fn.line(".")) > 0 and fn.col(".") == 1 then
--         fn.feedkeys("zc", "n")
--     else
--         fn.feedkeys("h", "n")
--     end
-- end)

keymap.set("n", "<leader>i", "~hi");
keymap.set("v", "<leader>i", "~gvI");

local opts = { silent = true }
keymap.set('n', '<leader>[', diagnostic.goto_prev, opts)
keymap.set('n', '<leader>]', diagnostic.goto_next, opts)

function SynStack()
    local stack = fn.synstack(fn.line('.'), fn.col('.'))
    local names = fn.map(stack, 'synIDattr(v:val, "name")')
    print(table.concat(names, ", "))
end
keymap.set('n', '<leader>z', SynStack)
