require "sanity"

return {
    filetype = { "javascript", "typescript", "typescriptreact" },
    allowed_status_codes = { 0, 2 },
    command = function(level)
        local cmd = array { "tsc", "--noEmit" }
        if level ~= vim.diagnostic.severity.ERROR then
            cmd:push("--noUnusedLocals", "--noUnusedParameters")
        end
        return cmd
    end,
    parse = function(line)
        local filename, lnum, cnum, level, text =
            line:match("^(.-)%((%d+),(%d+)%)%: (%w+) %w+%: (.-)$")
        if not text then return nil end
        local type, severity
        if level == "error" then
            severity = vim.diagnostic.severity.ERROR
            type = "E"
        elseif level == "warning" then
            severity = vim.diagnostic.severity.WARN
            type = "W"
        end
        return {
            filename = filename,
            type = type,
            level = severity,
            lnum = tonumber(lnum),
            col = tonumber(cnum),
            text = text,
        }
    end,
}
