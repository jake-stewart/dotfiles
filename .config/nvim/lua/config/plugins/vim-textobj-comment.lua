local plugin = require("config.util.plugin")

return plugin("glts/vim-textobj-comment")
    :deps("kana/vim-textobj-user")
    :map("o", "ic")
    :map("o", "ac")
    :setup()
