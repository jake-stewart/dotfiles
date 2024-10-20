local log = require "config.util.log"
local Spinner = require "config.util.spinner"

ERROR_SCANNERS = table {
    javascript = "config.scanner.typescript",
    typescript = "config.scanner.typescript",
    typescriptreact = "config.scanner.typescript",
}

--- @class ErrorScanner
--- @field private _scanning boolean
local ErrorScanner = {
    _scanning = false
}

--- @private
function ErrorScanner:canScan()
    if vim.o.filetype == "" then
        log.error("No filetype set", false)
        return false
    end
    if self._scanning then
        log.error("Already scanning for errors", false)
        return false
    end
    return true
end

--- @private
function ErrorScanner:getScanner(filetype)
    local scannerModule = ERROR_SCANNERS[filetype]
    if not scannerModule then
        log.error("No error scanner for " .. filetype, false)
        return nil
    end
    return require(scannerModule)
end

function ErrorScanner:scan(level)
    if not self:canScan() then
        return
    end
    local scanner = self:getScanner(vim.o.filetype)
    if not scanner then
        return
    end
    self._scanning = true
    local spinner = Spinner()
    spinner:start()
    scanner(level)
        :success(function(results)
            if #results == 0 then
                log.success("No issues found", false)
                return
            end
            log.info("", false)
            vim.fn.setqflist(results)
            vim.cmd.copen()
        end)
        :error(function(reason)
            log.error("Error: " .. tostring(reason))
        end)
        :finally(function()
            spinner:stop()
            self._scanning = false
        end)
end

return function(level)
    ErrorScanner:scan(level)
end
