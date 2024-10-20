local pack = function(...)
    return { n = select("#", ...), ... }
end

local unpack = function(t)
    return unpack(t, 1, t.n)
end

--- @class Range: tablelib
--- @field private start integer
--- @field private stop integer
--- @field private step integer
local Range = {}

function Range.__call(t, _, v)
    if v == nil then
        v = t.start
    else
        v = v + t.step
    end
    if t.start <= t.stop then
        if v < t.stop then
            return v
        end
    elseif v > t.stop then
        return v
    end
end

function Range.__index(t, k)
    local method = table[k]
    if method then
        return function(...)
            local result = {}
            local i = 1
            for n = t.start, t.stop, t.step do
                result[i] = n
                i = i + 1
            end
            local args = pack(...)
            if args[1] == t then
                args[1] = table(result)
            end
            return method(unpack(args))
        end
    end
end


--- @param start integer
--- @param stop integer | nil
--- @param step integer | nil
--- @return Range
--- @overload fun(stop: integer): Range
--- @overload fun(start: integer, stop: integer): Range
--- @diagnostic disable-next-line
function range(start, stop, step)
    start, stop = stop and start or 0, stop or start
    step = step or 1
    return setmetatable({
        start = start,
        stop = stop,
        step = step,
    }, Range)
end
