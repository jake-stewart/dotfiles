local plugin = require("config.util.plugin")

return plugin("machakann/vim-swap")
    :map("n", "gs", "<plug>(swap-interactive)")
    :setup()
