local map = vim.keymap.set

local function mapExpr(mode, key, rhs)
    vim.keymap.set(mode, key, rhs, { expr = true })
end

local function forceGoFile()
    local path = table({
        vim.fn.expand("%:p:h"),
        vim.fn.expand("<cfile>"),
    }):_join("/")
    if vim.fn.filereadable(path) == 0 then
        vim.cmd("silent! !touch " .. path)
    end
    vim.cmd.norm("gf")
end

local function getPopups()
    return table(vim.api.nvim_tabpage_list_wins(0))
        :_filter(function(id)
            return vim.api.nvim_win_get_config(id).zindex
        end)
end

local function killPopups()
    getPopups():_each(function(id)
        vim.api.nvim_win_close(id, false)
    end)
end

local function yankPopup()
    local popups = getPopups()
    if #popups == 1 then
        local id = popups[1]
        local buf = vim.api.nvim_win_get_buf(id)
        local lines = table(vim.api.nvim_buf_get_lines(buf, 0, -1, false))
        local content = lines:_join("\n")
        vim.fn.setreg("+", content)
    end
end

local function fixSpelling()
    local cword = vim.fn.expand("<cword>")
    local suggestions = vim.fn.spellsuggest("_" .. cword)
    local spelling = suggestions[1] or ""
    spelling = cword:_lower() == cword
        and spelling:_lower()
        or spelling
    if spelling:_match("\\v^[a-zA-Z -]+$")
        and cword ~= spelling
    then
        return "\"_ciw" .. spelling .. "\"_yiw"
    end
    return "\"_yiw"
end

map("n", "<esc>", function()
    vim.cmd.noh()
end)


map("n", "t<c-g>", function()
    -- vim.fn.setreg("+", vim.fn.getcwd())
    vim.fn.setreg("+", vim.fn.expand("%:p"))
end)

map("n", "<space>", "<NOP>")

map("n", "<leader>gf", forceGoFile)

-- repeat <c-r> to use unnamed register analogous to ""
map("i", "<c-r><c-r>", "<c-r>\"")

-- U makes more sense than <c-r> for redo
map("n", "U", "<c-r>")

-- my <c-k> is mapped <up> in tmux
map({"i", "c"}, "<up>", "<c-k>")

-- default <c-u> and <c-d> are disorientating
-- map("n", "<c-u>", "10k")
-- map("n", "<c-d>", "10j")

local function setupScroller()
    local state = {
        scrolling = false,
        didscroll = false
    }
    vim.api.nvim_create_autocmd("CursorMoved", {
        pattern = "*",
        callback = function()
            if not state.didscroll then
                state.scrolling = false
            end
            state.didscroll = false
        end
    })

    local function scroller(key)
        return function()
            state.didscroll = true
            if state.scrolling then
                vim.api.nvim_feedkeys("10" .. key .. "zz", "nx", false)
            else
                state.scrolling = true
                vim._with({ keepjumps = true }, function()
                    vim.api.nvim_feedkeys("M10" .. key .. "zz", "nx", false)
                end)
            end
        end
    end

    map({"n", "x"}, "<c-u>", scroller("k"))
    map({"n", "x"}, "<c-d>", scroller("j"))
end

setupScroller()


-- zero width space digraph
-- vim.cmd.digraphs("zs " .. 8203)
vim.cmd.digraphs("zs " .. 0x200b)

-- toggle cursor column
map("n", "<leader>cc", function()
    vim.o.cursorcolumn = not vim.o.cursorcolumn
end)

-- last changed region (works for paste, too)
map("o", ".", function()
    -- vim.fn.getregtype()
    --     :slice(0, 1)
    --     :surround("`[", "`]")
    --     [vim.cmd.norm]()
    vim.cmd.norm("`[" .. vim.fn.getregtype()[1] .. "`]")
end)
map("n", "tp", yankPopup)
-- map("n", "<esc>", function()
--     vim.cmd.noh()
--     killPopups()
-- end)

-- ^, $, and %, <c-^> are motions I use all the time
-- however, the keys are in awful positions
map({"n", "v", "o"}, "gh", "^")
map({"n", "v", "o"}, "gl", "$")
map({"n", "v", "o"}, "gm", "%")

-- 'A' is annoying because you have to release shift
-- this causes me to type ':' instead of ';' very often
map({"n", "v"}, "ga", "A")

-- I center screen all the time, zz is slow and hurts my finger
map({"n", "v"}, "gb", "zz")

-- fix spelling for cursor word
mapExpr("n", "<leader>ys", fixSpelling)

-- dd, yy, cc, etc all take too long since the same key is pressed twice
-- use dl, yl, cl etc instead
map("o", "l", "_")
map("o", "L", "_")
map("o", "c", "l")

map({"n", "v"}, "<c-b>", "<c-6>")

-- y is one of the hardest keys to press yet yanking is very common
-- t is easier to press yet t is never used outside of operator pending mode
map({"n", "v"}, "t", "y")
map({"n"}, "T", "y$")
map({"n", "v"}, "y", "<NOP>")

map("n", "<leader>i", "~hi")

map("n", "<leader>E", function()
    require("config.scanner")(vim.diagnostic.severity.ERROR)
end)

map("n", "<leader>W", function()
    require("config.scanner")(vim.diagnostic.severity.WARN)
end)

map("n", "<leader>o", vim.cmd.copen)

map("n", "<c-p>", function()
    pcall(vim.cmd.cprevious)
end)

map("n", "<c-n>", function()
    pcall(vim.cmd.cnext)
end)

map({"n", "v"}, "gK", "ga")
map({"n", "v"}, "-c", "\"_c")
map({"n", "v"}, "-d", "\"_d")
map({"n", "v"}, "-x", "\"_x")
map({"n", "v"}, "<c-_>", "/\\v")
map({"n", "v"}, "<c-/>", "/\\v")
map({"n", "v"}, "<leader>gq", ":!fmt -80 | sed 's/\\.  /. /g'<cr>")

map("n", "l", function()
    if vim.fn.foldclosed(".") ~= -1 then
        return "zo"
    end
    return "l"
end, { expr = true })

map("n", "h", function()
    if vim.fn.col(".") == 1 then
        if vim.fn.foldclosed(".") == -1 then
            if vim.fn.foldlevel(".") > 0 then
                return "zc"
            end
        end
    end
    return "h"
end, { expr = true })
