require "sanity"

local log = require "config.util.log"
local run = require "config.util.run"
local Spinner = require "config.util.spinner"

local SCANNERS = array {
    require "config.scanner.typescript",
    require "config.scanner.cs",
    require "config.scanner.rust",
}

local ERROR_SCANNERS = {}
for _, spec in SCANNERS do
    for _, ft in array(spec.filetype) do
        ERROR_SCANNERS[ft] = spec
    end
end

local function scan(spec, minimum_level)
    local function execute(context)
        local cmd = type(spec.command) == "function"
            and spec.command(minimum_level)
            or spec.command
        return run.capture_async(cmd, {
            allowed_status_codes = spec.allowed_status_codes
        }):success(function(result)
            local lines = array.concat(result.stdout, result.stderr):uniq()
            local items = array()
            for _, line in ipairs(lines) do
                local item = spec.parse(line, context)
                if item and ((not item.level) or item.level <= minimum_level) then
                    items:push(item)
                end
            end
            return items
        end)
    end

    if spec.setup then
        return spec.setup()
            :success(function(context)
                return execute(context)
            end)
    end

    return execute(nil)
end

--- @class ErrorScanner
--- @field private _scanning boolean
local ErrorScanner = {
    _scanning = false
}

--- @private
function ErrorScanner:can_scan()
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
function ErrorScanner:get_scanner(filetype)
    local spec = ERROR_SCANNERS[filetype]
    if not spec then
        log.error("No error scanner for " .. filetype, false)
        return nil
    end
    return spec
end

function ErrorScanner:scan(level)
    if not self:can_scan() then
        return
    end
    local spec = self:get_scanner(vim.o.filetype)
    if not spec then
        return
    end
    self._scanning = true
    local spinner = Spinner("scanning")
    spinner:start()
    scan(spec, level)
        :success(function(results)
            if #results == 0 then
                log.success("No issues found", false)
                return
            end
            vim.fn.setqflist(results)
            vim.cmd.copen()
        end)
        :error(function(reason)
            log.error("Error: " .. tostring(reason))
        end)
        :finally(function()
            self._scanning = false
            spinner:stop(false)
        end)
end

return function(level)
    ErrorScanner:scan(level)
end
