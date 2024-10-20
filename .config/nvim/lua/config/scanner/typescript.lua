local Promise = require("config.util.promise")

local function scanTscErrors(level)
    return Promise(function(resolve, reject)
        local cmd = table {"tsc", "--noEmit"}
        if level ~= vim.diagnostic.severity.ERROR then
            cmd:_push("--noUnusedLocals", "--noUnusedParameters")
        end
        local output

        local function onExit(status)
            local validStatusCodes = table { 0, 2 }
            if not validStatusCodes:_contains(status) then
                reject("invalid exit code")
            end
            output = table(output):_filter(function(line)
                return #line > 0 and line:_get(0) ~= " "
            end)
            resolve(output:_map(function(line)
                local colonIndex = line:_index(":") or 0
                local file = line:_slice(0, colonIndex + 1)
                local text = line:_slice(#file + 1):_trim()
                local lastParenIndex = -1
                while true do
                    local newLastParenIndex = file:_index(
                        "(", lastParenIndex + 1)
                    if newLastParenIndex then
                        lastParenIndex = newLastParenIndex
                    else
                        break
                    end
                end
                local filename = file:_slice(0, lastParenIndex)
                local commaIdx = file:_index(
                    ",", math.max(#filename + 1, 1)) or 0
                local closeParenIdx = file:_index(
                    ")", math.max(commaIdx + 1, 1)) or 0
                local lnum = file:_slice(#filename + 1, commaIdx)
                local cnum = file:_slice(commaIdx + 1, closeParenIdx)
                return {
                    filename = filename,
                    lnum = lnum,
                    col = cnum,
                    text = text,
                }
            end))
        end

        vim.fn.jobstart(cmd, {
            stdout_buffered = true,
            on_exit = function(_, status)
                local success, err = pcall(onExit, status)
                if not success then
                    reject(err)
                end
            end,
            on_stdout = function(_, stdout)
                output = stdout
            end
        })
    end)
end

return scanTscErrors
