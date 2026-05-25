return {
    "jake-stewart/normal-cmdline.nvim",
    dir = "~/clones/normal-cmdline.nvim/",
    -- event = "CmdlineEnter",
    enabled = false,
    config = function()
        vim.opt.guicursor:append("ci:ver1,c:ver1")
        local cmd = require("normal-cmdline")
        cmd.setup({
            key = "<c-g>",
            hl = "Normal",
            mappings = {
                ["k"] = cmd.history.prev,
                ["j"] = cmd.history.next,
                ["<cr>"] = cmd.accept,
                -- ["<esc>"] = cmd.cancel,
                ["<c-c>"] = cmd.cancel,
                [":"] = cmd.reset,
            }
        })
    end
}
