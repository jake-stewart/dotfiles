local log = require "config.util.log"

SPINNER_CHARS = table {
    "⠇",
    "⠋",
    "⠙",
    "⠸",
    "⠴",
    "⠦"
}

--- @class Spinner
--- @field private _frame integer
--- @field private _timer table
local SpinnerMetatable = {}
SpinnerMetatable.__index = SpinnerMetatable

--- @private
function SpinnerMetatable:_update()
    local char = SPINNER_CHARS:_at(self._frame)
    log.info(char .. " scanning", false)
    self._frame = (self._frame % #SPINNER_CHARS) + 1
end

function SpinnerMetatable:start()
    self._timer = vim.uv.new_timer()
    self._timer:start(100, 100, vim.schedule_wrap(function()
        self:_update()
    end))

end

function SpinnerMetatable:stop()
    if self._timer then
        self._timer:stop()
        self._timer = nil
    end
end

--- @return Spinner
function Spinner()
    return setmetatable({
        _frame = 1
    }, SpinnerMetatable)
end

return Spinner
