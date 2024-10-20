local plugin = require("config.util.plugin")

return plugin("delphinus/vim-firestore")
    :disable()
    :ft("firestore")
    :init(function()
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*.rules",
            callback = function()
                vim.o.filetype = "firestore"
            end
        })
    end)
    :setup()
