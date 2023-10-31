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
keymap.set("n", "<leader>gf", forceGoFile);

local function teleport(forward)
    local chars = {}
    local sl = vim.fn.line(".")
    local sc = vim.fn.col(".")

    local operator = forward and "/" or "?"
    local flag = forward and "" or "b"

    vim.cmd.echo("'" .. operator .. "'")
    local hlsearch = vim.o.hlsearch
    vim.o.hlsearch = false

    while #chars < 4 do
        local char = vim.fn.getchar()
        if char == 13 or char == 10 then
            break
        end
        vim.fn.cursor(sl, sc)
        if char == 27 then
            break
        elseif char == vim.api.nvim_replace_termcodes("<BS>", true, false, 0)
            or char == 27 or char == 8
        then
            if #chars then
                table.remove(chars)
            end
        elseif char == 27 or char == 8 or char ==
            vim.api.nvim_replace_termcodes("<BS>", true, false, 0)
        then
            table.remove(chars)
        elseif char == 21 then
            chars = {}
        elseif char == vim.fn.char2nr("'") then
        else
            table.insert(chars, vim.fn.nr2char(char))
        end
        local query = table.concat(chars, "")
        if query ~= "" then
            local ml = vim.fn.search(query, "nWz" .. flag)
            local line = vim.fn.getline(ml)
            local mc = vim.fn.match(line, query) + 1
            vim.cmd("match Search /\\V\\c" .. query .. "/")
            vim.cmd("2match IncSearch /\\V\\c\\%" .. ml .. "l\\%" .. mc  .. "c" .. query .. "/")
            vim.fn.cursor(ml, mc)
        else
            vim.cmd("match")
            vim.cmd("2match")
        end
        vim.cmd("redraw")
        vim.cmd.echo("'" .. operator .. query .. "'")
    end
    local query = table.concat(chars, "")
    vim.cmd.let("@/ = '" .. query .. "'")
    vim.o.hlsearch = hlsearch
    vim.cmd("match")
    vim.cmd("2match")
    vim.cmd.let("v:searchforward = " .. (forward and 1 or 0))

end
keymap.set("n", "t", function() teleport(true) end);
keymap.set("n", "T", function() teleport(false) end);

keymap.set("i", "<c-r><c-r>", "<c-r>\"");

keymap.set("n", "U", "<c-r>");

keymap.set("i", "<up>", "<c-k>");

keymap.set("n", "<c-u>", "10k");
keymap.set("n", "<c-d>", "10j");

-- zero width space digraph
cmd.digraph("zs " .. 0x200b)

-- toggle 80 char guide
keymap.set("n", "<leader>cc", function()
    o.cursorcolumn = not o.cursorcolumn
end)

-- visually select pasted content
keymap.set("n", "gp", function()
    return "`[" .. fn.strpart(fn.getregtype(), 0, 1) .. "`]"
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

-- clear search highlight & kill popups
keymap.set("n", "<esc>", function()
    vim.cmd.noh()
    killPopups()
end)

-- ^, $, and %, <c-^> are motions I use all the time
-- however, the keys are in awful positions
keymap.set({"n", "v", "o"}, "gh", "^")
keymap.set({"n", "v", "o"}, "gl", "$")
keymap.set({"n", "v", "o"}, "gm", "%")

keymap.set("n", "H", "H^")
keymap.set("n", "M", "M^")
keymap.set("n", "L", "L^")

-- I center screen all the time, zz is slow and hurts my finger
keymap.set({"n", "v"}, "gb", "zz")
keymap.set("n", "<c-o>", "<c-o>zz")
keymap.set("n", "<c-i>", "<c-i>zz")

keymap.set("n", "<leader>s", "1z=")

-- dd, yy, cc, etc all take too long since the same key is pressed twice
-- use dl, yl, cl etc instead
keymap.set("o", "l", "_")
keymap.set("o", "L", "_")
keymap.set("o", ".", "l")

-- y is one of the hardest keys to press yet yanking is very common
-- t is easier to press yet t is never used outside of operator pending mode
keymap.set({"n", "v"}, "t", "y")
keymap.set({"n", "v"}, "y", "<NOP>")

-- make l open fold even if at EOL
-- keymap.set("n", "l", function()
--     if fn.foldclosed(fn.line(".")) == -1 then
--         fn.feedkeys("l", "n")
--     else
--         cmd.foldopen() end
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
keymap.set('n', '<leader>h', diagnostic.goto_prev, opts)
keymap.set('n', '<leader>l', diagnostic.goto_next, opts)
