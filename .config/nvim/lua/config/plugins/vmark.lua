return require "lazier" {
    "jake-stewart/vmark.nvim",
    dir = "~/clones/vmark.nvim",
    event = "VeryLazy",
    config = function()
        local vmark = require("vmark")

        vmark.setup({
            format = function(details)
                return {
                    virt_text = {{ " ◼ " .. details.text .. " ", "VMark" }},
                    hl_mode = "combine",
                    virt_text_pos = "eol", -- "right_align",
                    sign_hl_group = "VMarkSign",
                    sign_text = ">>",
                }
            end
        })

        vim.keymap.set("n", "ma", vmark.create)
        vim.keymap.set("n", "mo", vmark.recursiveQuickfix)
        vim.keymap.set("n", "md", vmark.removeUnderCursor)
        vim.keymap.set("n", "me", vmark.echoUnderCursor)
        vim.keymap.set({"n", "v", "o"}, "mk", vmark.prev)
        vim.keymap.set({"n", "v", "o"}, "mj", vmark.next)

        local searchHl = vim.api.nvim_get_hl(0, { name = "Search", link = false })
        local infoHl = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo", link = false })
        vim.api.nvim_set_hl(0, "VMark", table._spread(searchHl, infoHl, { cterm = { bold = true }}))
        vim.api.nvim_set_hl(0, "VMarkSign", table._spread(infoHl, { cterm = { bold = true }}))
    end
}
