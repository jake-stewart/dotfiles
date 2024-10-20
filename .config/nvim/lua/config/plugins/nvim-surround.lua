local plugin = require("config.util.plugin")

return plugin("kylechui/nvim-surround")
    -- :disable()
    :module("nvim-surround")
    :map("n", "ys")
    :map("n", "cs")
    :map("n", "ds")
    :map("v", "ys")
    :setup({
        keymaps = {
            insert = false,
            insert_line = false,
            normal = "ys",
            normal_cur = false,
            normal_line = false,
            normal_cur_line = false,
            visual = "ys",
            visual_line = false,
            delete = "ds",
            change = "cs"
        }
    })
