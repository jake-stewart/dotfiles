require("config")

local function tabStopMove(direction)
    local tabstop = vim.o.softtabstop
    local indent = vim.fn.indent(".")
    local line = vim.fn.getline(".")
    local cnum = vim.fn.col(".")
    local key = vim.api.nvim_replace_termcodes(
        direction == -1 and "<left>" or "<right>", true, true, true)
    local total = 0
    local offset = math.min(direction, 0)
    for _ = 1, vim.v.count1 do
        local ncol = 1
        if (cnum + offset) <= indent and line:sub(cnum + offset, cnum + offset) == " " then
            if direction == -1 then
                ncol = ((cnum - 1) % tabstop)
                if ncol == 0 then
                    ncol = 4
                end
            else
                ncol = tabstop - ((cnum - 1) % tabstop)
            end
        end
        total = total + ncol
        cnum = cnum + ncol * direction
        if cnum <= 1 then
            total = total + math.min(cnum, 0)
            break
        end
    end
    if total > 0 then
        local mode = vim.fn.mode()
        if mode == "i" or mode == "R" then
            return string.rep(key, total)
        else
            return total .. key
        end
    end
    return ""
end

-- for _, item in ipairs({
--     { direction = -1, key = "<left>" },
--     { direction = 1, key = "<right>" }
-- }) do
--     vim.keymap.set(
--         {"n", "o", "x", "i"},
--         item.key,
--         function()
--             return tabStopMove(item.direction)
--         end,
--         { expr = true, replace_keycodes = false }
--     )
-- end


