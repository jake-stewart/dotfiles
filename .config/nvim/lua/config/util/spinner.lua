require "sanity"

local log = require "config.util.log"

SPINNER_CHARS = array {
    "⠇",
    "⠋",
    "⠙",
    "⠸",
    "⠴",
    "⠦"
}

--- @class Spinner
--- @field private _text string
--- @field private _frame integer
--- @field private _timer table
local SpinnerMetatable = {}
SpinnerMetatable.__index = SpinnerMetatable

--- @private
function SpinnerMetatable:_update()
    local char = SPINNER_CHARS[self._frame]
    log.info(char .. " " .. self._text, false)
    self._frame = (self._frame % #SPINNER_CHARS) + 1
end

function SpinnerMetatable:start()
    self._timer = vim.uv.new_timer()
    self._timer:start(100, 100, vim.schedule_wrap(function()
        self:_update()
    end))

end

--- @param clear? boolean
function SpinnerMetatable:stop(clear)
    if self._timer then
        if clear ~= false then
            log.info("", false)
        end
        self._timer:stop()
        self._timer:close()
        self._timer = nil
    end
end

--- @param text string
--- @return Spinner
function Spinner(text)
    return setmetatable({
        _text = text or "",
        _frame = 1
    }, SpinnerMetatable)
end

return Spinner
