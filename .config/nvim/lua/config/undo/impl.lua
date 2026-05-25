local M = {}

-- :h clear-undo
local function refresh_undolevels()
    vim.cmd.normal(vim.api.nvim_replace_termcodes("a <bs><esc>", true, true, true))
    local pos = vim.fn.getcurpos()
    vim.cmd.undo()
    vim.fn.setpos(".", pos)
end

function M.writeundo()
    vim.cmd.wundo(vim.fn.fnameescape(vim.fn.undofile(vim.fn.expand("%"))))
end

--- @param opts TidyUndodirOpts
function M.readundo(opts)
    local undofile = vim.fn.undofile(vim.fn.expand("%"))
    if vim.fn.filereadable(undofile) == 0 then
        vim.fn.undolevels = opts.max_undo_items
        return
    end

    vim.cmd("silent rundo " .. vim.fn.fnameescape(undofile))

    local time = vim.fn.localtime()
    local undotree = vim.fn.undotree(vim.fn.bufnr())

    if #undotree.entries <= opts.min_undo_items then
        return
    end

    local num_to_delete = 0
    for _, entry in ipairs(undotree.entries) do
        if time - entry.time > opts.max_age then
            num_to_delete = num_to_delete + 1
        else
            break
        end
    end

    if num_to_delete > 0 then
        vim.o.undolevels = math.max(
            opts.min_undo_items, #undotree.entries - num_to_delete)
        refresh_undolevels()
        vim.cmd("silent wundo " .. vim.fn.fnameescape(undofile))
        vim.schedule(function()
            vim.o.undolevels = opts.max_undo_items
        end)
    end
end

--- @param opts TidyUndodirOpts
function M.setup(opts)
    vim.o.undodir = opts.undodir or table.concat(
        {vim.fn.stdpath("state"), "undo"},
        vim.fn.has("win32") == 1 and "\\" or "/"
    )

    if vim.fn.isdirectory(vim.o.undodir) == 0 then
        ---@diagnostic disable-next-line
        vim.fn.mkdir(vim.o.undodir, "p", 770)
    end

    local group = vim.api.nvim_create_augroup("expiring-undodir", { clear = true })

    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        group = group,
        callback = function()
            require("config.undo.impl").readundo(opts)
        end
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*",
        group = group,
        callback = function()
            require("config.undo.impl").writeundo()
        end
    })
end

return M
