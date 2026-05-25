local M = {}

--- @class TidyUndodirOpts
--- @field max_age? integer
--- @field min_undo_items? integer
--- @field max_undo_items? integer
--- @field undodir? string

--- @param opts? TidyUndodirOpts
function M.setup(opts)
    opts = vim.tbl_extend("keep", opts or {}, {
        max_age = 60 * 60 * 24 * 7,
        min_undo_items = 100,
        max_undo_items = 10000
    })

    vim.o.undofile = false
    vim.o.undolevels = opts.max_undo_items

    vim.schedule(function()
        require("config.undo.impl").setup(opts)
    end)
end

return M
