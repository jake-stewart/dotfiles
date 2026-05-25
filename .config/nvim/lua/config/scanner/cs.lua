require "sanity"

return {
    filetype = { "cs" },
    command = {
        "dotnet",
        "build",
        "-nologo",
        "-consoleloggerparameters:NoSummary",
        "-v",
        "q",
    },
    allowed_status_codes = { 0, 1 },
    parse = function(line)
        local filename, lnum, cnum, level, text =
            line:match("^(.-)%((%d+),(%d+)%): (%w+) %w+: (.-)%s*%[")
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
