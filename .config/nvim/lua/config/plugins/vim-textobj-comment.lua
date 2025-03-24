return require "lazier" {
    "glts/vim-textobj-comment",
    dependencies = { "kana/vim-textobj-user" },
    keys = {
        { "ic", mode = { "o", "v" } },
        { "ac", mode = { "o", "v" } },
    }
}
