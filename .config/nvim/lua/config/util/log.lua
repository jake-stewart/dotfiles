local log = {}
setmetatable(log, log)

function log.__call(...)
    vim.print(...)
end

--- @param message string
--- @param history? boolean
function log.info(message, history)
    if history == nil then
        history = true
    end
    vim.api.nvim_echo({{ message, "Normal" }}, history, {})
end

--- @param message string
--- @param history? boolean
function log.error(message, history)
    if history == nil then
        history = true
    end
    vim.api.nvim_echo({{ message, "ErrorMsg" }}, history, {})
end

--- @param message string
--- @param history? boolean
function log.warn(message, history)
    if history == nil then
        history = true
    end
    vim.api.nvim_echo({{ message, "WarningMsg" }}, history, {})
end

--- @param message string
--- @param history? boolean
function log.success(message, history)
    if history == nil then
        history = true
    end
    vim.api.nvim_echo({{ message, "DiffAdd" }}, history, {})
end

return log
