return require "lazier" {
    "jake-stewart/multicursor.nvim",
    dir = "~/clones/multicursor.nvim",
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()

        mc.addKeymapLayer(function(set)
            set({"n", "v"}, "H", function() mc.swapCursors(-1) end)
            set({"n", "v"}, "L", function() mc.swapCursors(1) end)
            set("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)

        local map = vim.keymap.set

        map({"n", "v"}, "ga", mc.addCursorOperator)
        map({"n", "v"}, "<leader>gv", mc.restoreCursors)
        map({"n", "v"}, "<c-q>", mc.toggleCursor)
        map({"n", "v"}, "<leader><c-q>", mc.duplicateCursors)
        map({"n", "v"}, "<up>", function() mc.lineAddCursor(-1) end)
        map({"n", "v"}, "<down>", function() mc.lineAddCursor(1) end)
        map({"n", "v"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
        map({"n", "v"}, "<leader><down>", function() mc.lineSkipCursor(1) end)
        map("n", "<leader>a", mc.alignCursors)
        map({"n", "v"}, "<c-h>", mc.prevCursor)
        map({"n", "v"}, "<c-l>", mc.nextCursor)
        map({"n", "v"}, "<leader>x", mc.deleteCursor)

        map({"n", "v"}, "<leader>da", mc.diagnosticAddCursor)
        map({"n", "v"}, "<leader>ds", mc.diagnosticSkipCursor)
        map({"n", "v"}, "<leader>dA", mc.diagnosticMatchCursors)

        map({"n", "x"}, "<leader>A", mc.matchAllAddCursors)
        map({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end)
        map({"n", "x"}, "<leader>s", function() mc.matchSkipCursor(1) end)
        map({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end)
        map({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end)

        map({"n", "v"}, "<c-leftmouse>", mc.handleMouse)
        map({"n", "v"}, "<c-leftdrag>", mc.handleMouseDrag)
        map({"n", "v"}, "<c-leftrelease>", mc.handleMouseRelease)
        map("v", "S", mc.splitCursors)

        map("v", "M", mc.matchCursors)
        -- -- map("v", "M", mc.textObjects())
        map({"n", "x"}, "<leader>M", mc.operator)

        -- map("v", "<leader>t", mc.transposeCursors(1))
        -- map("v", "<leader>T", mc.transposeCursors(-1))
        map("v", "I", mc.insertVisual)
        map("v", "A", mc.appendVisual)
        map("v", "<leader><esc>", mc.visualToCursors)

        map("i", "<c-a>", function()
            vim.api.nvim_feedkeys("<esc>", "nx", true)
            require("multicursor-nvim").action(function(ctx)
                ctx:forEachCursor(function(cursor)
                    cursor:feedkeys("$")
                end)
            end)
        end)

        -- vim.api.nvim_set_hl(0, "MultiCursorCursor", { ctermbg = 250, ctermfg = "black" })
        -- vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
        -- vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { ctermbg = 240, ctermfg = "white" })
        -- vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        -- vim.api.nvim_set_hl(0, "MultiCursorMainSign", { link = "CursorLineSign" })
    end,
}
