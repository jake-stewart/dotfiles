local plugin = require("config.util.plugin")

return plugin("junegunn/vim-easy-align")
    :disable()
    :map({"n", "v"}, "<leader>a", "<plug>(EasyAlign)")
    :setup()
