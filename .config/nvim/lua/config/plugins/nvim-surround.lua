return require "lazier" {
    "kylechui/nvim-surround",
    keys = {
        { "ys", mode = "n" },
        { "cs", mode = "n" },
        { "ds", mode = "n" },
        { "ys", mode = "v" },
    },
    opts = {
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
    }
}
