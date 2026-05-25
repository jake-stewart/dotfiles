local Promise = require "config.util.promise"

--- @class RunResult
--- @field command string[]
--- @field status integer?
--- @field stdout string[]?
--- @field stderr string[]?

local RunResult = {}
RunResult.__index = RunResult

local function new_result(command, status, stdout, stderr)
    return setmetatable({
        command = command,
        status = status,
        stdout = stdout,
        stderr = stderr,
    }, RunResult)
end

local function split_output(text)
    local lines = vim.split(text, "\n", { plain = true })
    if lines[#lines] == "" then
        table.remove(lines)
    end
    return lines
end

--- @class RunOpts
--- @field allowed_status_codes integer[]?
--- @field cwd string?
--- @field env table<string, string>?

--- @class CaptureOpts : RunOpts
--- @field expect_num_lines integer?

--- @param command string[]
--- @param opts CaptureOpts?
--- @return RunResult
local function capture(command, opts)
    opts = opts or {}
    local allowed = opts.allowed_status_codes or { 0 }

    local obj = vim.system(command, {
        text = true,
        cwd = opts.cwd,
        env = opts.env,
    }):wait()

    local result = new_result(
        command,
        obj.code,
        split_output(obj.stdout or ""),
        split_output(obj.stderr or "")
    )

    if not vim.tbl_contains(allowed, result.status) then
        error(result)
    end
    if opts.expect_num_lines ~= nil and #result.stdout ~= opts.expect_num_lines then
        error(result)
    end

    return result
end

--- @param command string[]
--- @param opts CaptureOpts?
--- @return Promise<RunResult>
local function capture_async(command, opts)
    opts = opts or {}
    local allowed = opts.allowed_status_codes or { 0 }

    return Promise(function(resolve, reject)
        vim.system(command, {
            text = true,
            cwd = opts.cwd,
            env = opts.env,
        }, function(obj)
            local result = new_result(
                command,
                obj.code,
                split_output(obj.stdout or ""),
                split_output(obj.stderr or "")
            )

            if not vim.tbl_contains(allowed, result.status) then
                return reject("process finished with exit code " .. result.status)
            end
            if opts.expect_num_lines ~= nil
                and #result.stdout ~= opts.expect_num_lines
            then
                return reject("process stdout contained " .. #result.stdout
                        .. " line(s) (expected " .. opts.expect_num_lines .. ")")
            end

            resolve(result)
        end)
    end)
end

--- @param command string[]
--- @param opts RunOpts?
--- @return RunResult
local function interactive(command, opts)
    opts = opts or {}
    local allowed = opts.allowed_status_codes or { 0 }

    local job_id = vim.fn.jobstart(command, {
        cwd = opts.cwd,
        env = opts.env,
    })

    if job_id <= 0 then
        error(new_result(command, job_id))
    end

    local status = vim.fn.jobwait({ job_id })[1]
    local result = new_result(command, status)

    if not vim.tbl_contains(allowed, status) then
        error(result)
    end

    return result
end

--- @param err unknown
--- @return boolean
local function is_error(err)
    return type(err) == "table" and getmetatable(err) == RunResult
end

--- @class Run
--- @field capture fun(command: string[], opts?: CaptureOpts): RunResult
--- @field capture_async fun(command: string[], opts?: CaptureOpts): Promise<RunResult>
--- @field interactive fun(command: string[], opts?: RunOpts): RunResult
--- @field is_error fun(err: unknown): boolean
--- @overload fun(command: string[], opts?: CaptureOpts): RunResult

--- @type Run
return setmetatable({
    capture = capture,
    capture_async = capture_async,
    interactive = interactive,
    is_error = is_error,
}, {
    __call = function(_, command, opts)
        return capture(command, opts)
    end,
})
