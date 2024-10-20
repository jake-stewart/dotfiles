local plugin = require("config.util.plugin")

local function escHandler(mc)
    if not mc.cursorsEnabled() then
        mc.enableCursors()
    elseif mc.hasCursors() then
        mc.clearCursors()
    else
        vim.cmd.noh()
    end
end

return plugin("jake-stewart/multicursor.nvim")
    -- :disable()
    :dir("~/clones/multicursor.nvim")
    :module("multicursor-nvim")

    :map("n", "<esc>", escHandler)
    :map({"n", "v"}, "ga", plugin.addCursorOperator())
    :map({"n", "v"}, "<leader>gv", plugin.restoreCursors())
    :map({"n", "v"}, "<c-q>", plugin.toggleCursor())
    :map({"n", "v"}, "<leader><c-q>", plugin.duplicateCursors())
    :map({"n", "v"}, "<up>", plugin.lineAddCursor(-1))
    :map({"n", "v"}, "<down>", plugin.lineAddCursor(1))
    :map({"n", "v"}, "<leader><up>", plugin.lineSkipCursor(-1))
    :map({"n", "v"}, "<leader><down>", plugin.lineSkipCursor(1))
    :map("n", "<leader>a", plugin.alignCursors())
    :map({"n", "v"}, "<c-h>", plugin.prevCursor())
    :map({"n", "v"}, "<c-l>", plugin.nextCursor())
    :map({"n", "v"}, "<leader>x", plugin.deleteCursor())
    :map({"n", "x"}, "<leader>A", plugin.matchAllAddCursors())
    :map({"n", "x"}, "<leader>n", plugin.matchAddCursor(1))
    :map({"n", "x"}, "<leader>s", plugin.matchSkipCursor(1))
    :map({"n", "x"}, "<leader>N", plugin.matchAddCursor(-1))
    :map({"n", "x"}, "<leader>S", plugin.matchSkipCursor(-1))
    :map({"n", "v"}, "<c-leftmouse>", plugin.handleMouse())
    :map("v", "S", plugin.splitCursors())
    :map("v", "M", plugin.matchCursors())
    :map("v", "<leader>t", plugin.transposeCursors(1))
    :map("v", "<leader>T", plugin.transposeCursors(-1))
    :map("v", "I", plugin.insertVisual())
    :map("v", "A", plugin.appendVisual())
    :map("v", "<leader><esc>", plugin.visualToCursors())

    :hl("MultiCursorCursor", { ctermbg = 250, ctermfg = "black" })
    :hl("MultiCursorVisual", { link = "Visual" })
    :hl("MultiCursorDisabledCursor", { ctermbg = 240, ctermfg = "white" })
    :hl("MultiCursorDisabledVisual", { link = "Visual" })
    :hl("MultiCursorMainSign", { link = "CursorLineSign" })

    :setup(function(mc)
        mc.setup()


    end)
