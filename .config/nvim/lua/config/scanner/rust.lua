local run = require "config.util.run"

local function getRustWorkspaceRoot()
    return run.capture_async({
        "cargo",
        "metadata",
        "--quiet",
        "--offline",
        "--color=never",
        "--format-version=1",
    }):success(function(result)
        return vim.json.decode(
            table.concat(result.stdout, "")).workspace_root
    end)
end

return {
    filetype = { "rust" },
    command = {
        "cargo",
        "check",
        "--quiet",
        "--offline",
        "--color=never",
        "--message-format=short",
    },
    allowed_status_codes = { 0, 101 },
    setup = getRustWorkspaceRoot,
    parse = function(line, root)
        local filename, lnum, cnum, level, text =
            line:match("^(.-)%:(%d+)%:(%d+)%: (%w+)%[?.-: (.-)$")
            -- line:match("^(.-)%:(%d+)%:(%d+)%: (%w+)%: (.-)$")
        if not text then
            return nil
        end
        local type, severity
        if level == "error" then
            severity = vim.diagnostic.severity.ERROR
            type = "E"
        elseif level == "warning" then
            severity = vim.diagnostic.severity.WARN
            type = "W"
        end
        return {
            filename = root .. "/" .. filename,
            type = type,
            level = severity,
            lnum = tonumber(lnum),
            col = tonumber(cnum),
            text = text,
        }
    end,
}
