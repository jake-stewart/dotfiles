local function forceGoFile()
    local fname = vim.fn.expand("<cfile>")
    local path = vim.fn.expand("%:p:h") .. "/" .. fname
    if vim.fn.filereadable(path) ~= 1 then
        vim.cmd("silent! !touch " .. path)
    end
    vim.cmd.norm("gf")
end

vim.keymap.set("n", "<leader>gf", forceGoFile, {silent=true});

local function scroll(direction)
    local scrolloff = vim.o.scrolloff
    vim.o.scrolloff = 999
    vim.cmd.norm("10" .. direction)
    vim.o.scrolloff = scrolloff
end

vim.keymap.set("n", "<c-u>", function() scroll("k") end);
vim.keymap.set("n", "<c-d>", function() scroll("j") end);

-- zero width space digraph
vim.cmd.digraph("zs " .. 0x200b)

-- toggle 80 char guide
vim.keymap.set("n", "<leader>cc", function()
    vim.o.cursorcolumn = not vim.o.cursorcolumn
end)

-- toggle color column
vim.keymap.set("n", "<leader>8", function()
    vim.o.cc = vim.o.cc == "80" and "0" or "80"
end)

-- visually select pasted content
vim.keymap.set("n", "gp", function()
    return "`[" .. vim.fn.strpart(vim.fn.getregtype(), 0, 1) .. "`]"
end, {expr=true})

-- clear search highlight
vim.keymap.set("n", "<esc>", function()
    vim.o.hlsearch = false
end)

-- ^, $, and %, <c-^> are motions I use all the time
-- however, the keys are in awful positions
vim.keymap.set({"n", "v"}, "gh", "^")
vim.keymap.set({"n", "v"}, "gl", "$")
vim.keymap.set({"n", "v"}, "gm", "%")

vim.keymap.set("n", "H", "H^")
vim.keymap.set("n", "M", "M^")
vim.keymap.set("n", "L", "L^")

-- I center screen all the time, zz is slow and hurts my finger
vim.keymap.set("n", "gb", "zz")
vim.keymap.set("n", "<c-o>", "<c-o>zz")
vim.keymap.set("n", "<c-i>", "<c-i>zz")

vim.keymap.set("n", "<leader>s", "1z=")

-- dd, yy, cc, etc all take too long since the same key is pressed twice
-- use dl, yl, cl etc instead
vim.keymap.set("o", "l", "_")
vim.keymap.set("o", "c", "l")

-- make l open fold even if at EOL
vim.keymap.set(
    "n", "l", ":silent! norm zo<CR>l",
    {silent=true}
)

vim.keymap.set("n", "<leader>i", "~hi");
vim.keymap.set("v", "<leader>i", "~gvI");

local opts = { silent = true }
vim.keymap.set('n', '<leader>[', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>]', vim.diagnostic.goto_next, opts)

function SynStack()
    local stack = vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.'))
    local names = vim.fn.map(stack, 'synIDattr(v:val, "name")')
    print(table.concat(names, ", "))
end
vim.keymap.set('n', '<leader>z', SynStack)
