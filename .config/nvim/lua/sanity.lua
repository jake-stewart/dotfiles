--- @diagnostic disable-next-line
sane = true

--- @diagnostic disable-next-line
table.unpack = table.unpack or unpack

local pack = function(...)
    return { n = select("#", ...), ... }
end

local unpack = function(t)
    return table.unpack(t, 1, t.n)
end

--- @generic T
--- @class Array<T>: { [integer]: T }
--- @overload fun(t?: table): Array
array = {}

local array_mt = {
    __index = array,
    __call = function(t, _, i)
        i = (i or 0) + 1
        local item = t[i]
        if item then
            return i, item
        end
    end,
}

setmetatable(array, {
    __call = function(_, t)
        return setmetatable(t or {}, array_mt)
    end,
})

local inspect_mod = require("vim.inspect")
local inspect = inspect_mod.inspect

-- the metatable showing up in vim.inspect/vim.print is distracting
--- @diagnostic disable-next-line
function inspect_mod.inspect(x, opts)
    opts = opts or {}
    local process = opts.process
        or function(y) return y end
    opts.process = function(y)
        if getmetatable(y) == array_mt then
            y = setmetatable(y:clone(), nil)
        end
        return process(y)
    end
    return inspect(x, opts)
end

--- @generic T
--- @generic R
--- @param t Array<T>
--- @param fn fun(t: Array<T>, ...): R
--- @param ... any
--- @return R
function array.pipe(t, fn, ...)
    return fn(t, unpack(pack(...)))
end

--- @generic T
--- @param t Array<T>
--- @param fn fun(t: Array<T>, ...)
--- @param ... any
--- @return Array<T>
function array.peek(t, fn, ...)
    fn(t, unpack(pack(...)))
    return t
end

--- @generic T
--- @param t Array<T>
--- @param i integer
--- @return T
function array.at(t, i)
    return t[i < 0 and #t + i + 1 or i]
end

--- @generic T
--- @param t Array<T>
--- @param k integer
--- @param default T
--- @return T
function array.get(t, k, default)
    local item = t[k]
    if item == nil then
        t[k] = default
        return default
    end
    return item
end

--- @generic T
--- @param t Array<T>
--- @param ... T
--- @return Array<T>
function array.push(t, ...)
    local args = pack(...)
    for i = 1, args.n do
        table.insert(t, args[i])
    end
    return t
end

--- @generic T
--- @param t Array<T>
--- @return T
function array.pop(t)
    return table.remove(t)
end

--- @generic T
--- @param t Array<T>
--- @param value T
--- @param idx? integer
function array.insert(t, value, idx)
    table.insert(t, value, idx)
end

--- @generic T
--- @param t Array<T>
--- @param idx integer
--- @return T
function array.remove(t, idx)
    return table.remove(t, idx)
end

--- @generic T
--- @param t Array<T>
--- @param start? integer
--- @param stop? integer
--- @return Array<T>
function array.slice(t, start, stop)
    local result = {}
    stop = stop or #t
    for i = start, stop do
        table.insert(result, t[i])
    end
    return array(result)
end

--- @generic T
--- @param t Array<T>
--- @param start integer
--- @param deleteCount integer
--- @param ... T
--- @return Array<T>
function array.splice(t, start, deleteCount, ...)
    local newItems = { ... }
    deleteCount = math.max(0, deleteCount)
    local temp = {}
    local spliced = {}
    for i = start, start + deleteCount - 1 do
        table.insert(spliced, t[i])
    end
    for i = start + deleteCount, #t do
        table.insert(temp, t[i])
    end
    for i = 1, #newItems do
        t[start + i - 1] = newItems[i]
    end
    start = start + #newItems - 1
    for i = 1, #temp do
        t[start + i] = temp[i]
    end
    for _ = 1, #t - (start + #temp) do
        table.remove(t)
    end
    return array(spliced)
end

--- @generic T
--- @param t Array<T>
--- @return T ...
function array.unpack(t)
    return table.unpack(t)
end

--- @generic T
--- @param t Array<T>
--- @return Array<T>
function array.clone(t)
    local result = {}
    for k, v in pairs(t) do
        result[k] = v
    end
    return array(result)
end

--- @generic T
--- @param t Array<T>
--- @param func fun(a: T, b: T): boolean
--- @return Array<T>
function array.sort(t, func)
    table.sort(t, func)
    return t
end

--- @generic T
--- @param t Array<T>
--- @return Array<T>
function array.reverse(t)
    local i = 1
    local j = #t
    while i < j do
        t[i], t[j] = t[j], t[i]
        i = i + 1
        j = j - 1
    end
    return t
end

--- @generic T
--- @param t Array<T>
--- @return Array<T>
function array.uniq(t)
    local result = {}
    local exists = {}
    local hasNaN = false
    local n = 1
    local i = 1
    for k, v in pairs(t) do
        if k == i then
            i = i + 1
            if v ~= v and type(v) == "number" then
                if not hasNaN then
                    hasNaN = true
                    result[n] = v
                    n = n + 1
                end
            elseif not exists[v] then
                exists[v] = true
                result[n] = v
                n = n + 1
            end
        else
            if v ~= v and type(v) == "number" then
                if not hasNaN then
                    hasNaN = true
                    result[k] = v
                end
            elseif not exists[v] then
                exists[v] = true
                result[k] = v
            end
        end
    end
    return array(result)
end

--- @generic T
--- @param ... Array<T> | table
--- @return Array<T>
function array.concat(...)
    local result = {}
    for _, t in ipairs({...}) do
        for _, v in ipairs(t) do
            table.insert(result, v)
        end
    end
    return array(result)
end

--- @generic T
--- @param t Array<T>
--- @return Array<T>
function array.clear(t)
    for i = #t, 1, -1 do
        t[i] = nil
    end
    return t
end

local function flatten(result, t, depth, maxDepth)
    if depth == maxDepth then
        for _, value in pairs(t) do
            table.insert(result, value)
        end
    else
        for _, value in pairs(t) do
            if type(value) == "table" then
                flatten(result, value, depth + 1, maxDepth)
            else
                table.insert(result, value)
            end
        end
    end
    return result
end

--- @generic T
--- @param t Array<T|Array<T>>
--- @param depth? integer
--- @return Array<T>
function array.flat(t, depth)
    return array(flatten({}, t, 0, depth or 1))
end

--- @generic T
--- @param t Array<T>
--- @param callback fun(value: T, k: integer): boolean
--- @return Array<T>
function array.filter(t, callback)
    local result = {}
    local n = 1
    local i = 1
    for k, v in pairs(t) do
        if k == i then
            i = i + 1
            if callback(v, k) then
                result[n] = v
                n = n + 1
            end
        else
            if callback(v, k) then
                result[k] = v
            end
        end
    end
    return array(result)
end

--- @generic T
--- @generic R
--- @param t Array<T>
--- @param callback fun(value: T, k: integer): R
--- @return Array<R>
function array.map(t, callback)
    local result = {}
    for i, v in ipairs(t) do
        result[i] = callback(v, i)
    end
    return array(result)
end

--- @generic T
--- @generic R
--- @param t Array<T>
--- @param reducer fun(acc: R, value: T): R
--- @param initialValue? R
--- @return R
function array.reduce(t, reducer, initialValue)
    local accumulator = initialValue
    local startIndex = 1
    if initialValue == nil then
        accumulator = t[1]
        startIndex = 2
    end
    for i = startIndex, #t do
        accumulator = reducer(accumulator, t[i])
    end
    return accumulator
end

--- @generic T
--- @param t Array<T>
--- @param callback fun(value: T, k: integer)
--- @return Array<T>
function array.each(t, callback)
    for k, v in pairs(t) do
        callback(v, k)
    end
    return t
end

--- @generic T
--- @param t Array<T>
--- @param callback fun(value: T, k: integer): boolean | nil
--- @return boolean
function array.any(t, callback)
    for k, v in pairs(t) do
        if callback(v, k) then
            return true
        end
    end
    return false
end

--- @generic T
--- @param t Array<T>
--- @param callback fun(value: T, k: integer): boolean | nil
--- @return boolean
function array.all(t, callback)
    for k, v in pairs(t) do
        if not callback(v, k) then
            return false
        end
    end
    return true
end

--- @generic T
--- @param t Array<T>
--- @param sep? string
--- @return string
function array.join(t, sep)
    return table.concat(t, sep or "")
end

--- @generic T
--- @param t Array<T>
--- @return Array<integer>
function array.keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return array(keys)
end

--- @generic T
--- @param t Array<T>
--- @return Array<T>
function array.values(t)
    local values = {}
    for _, v in pairs(t) do
        table.insert(values, v)
    end
    return array(values)
end

--- @generic T
--- @param t Array<T>
--- @return Array<Array<integer|T>>
function array.entries(t)
    local entries = {}
    for k, v in pairs(t) do
        table.insert(entries, array({ k, v }))
    end
    return array(entries)
end

--- @generic T
--- @param ... Array<T>
--- @return Array<T>
function array.spread(...)
    local result = {}
    local items = pack(...)
    for i = 1, items.n do
        local t = items[i]
        if t then
            for k, v in pairs(t) do
                result[k] = v
            end
        end
    end
    return array(result)
end

--- @generic T
--- @param t Array<T>
--- @param element T
--- @return boolean
function array.contains(t, element)
    for _, v in ipairs(t) do
        if v == element then
            return true
        end
    end
    return false
end

--- @generic T
--- @param t Array<T>
--- @param element T
--- @param start_at? integer
--- @return integer | nil
function array.index(t, element, start_at)
    for i = start_at or 1, #t do
        if t[i] == element then
            return i
        end
    end
    return nil
end

--- @generic T
--- @param t Array<T>
--- @param element T
--- @param start_at? integer
--- @return integer | nil
function array.last_index(t, element, start_at)
    for i = start_at or #t, 1, -1 do
        if t[i] == element then
            return i
        end
    end
    return nil
end

--- @generic T
--- @param t Array<T>
--- @param callback fun(value: T, index: integer): boolean
--- @param start_at? integer
--- @return T | nil, integer | nil
function array.find(t, callback, start_at)
    for i = start_at or 1, #t do
        if callback(t[i], i) then
            return t[i], i
        end
    end
    return nil
end

--- @generic T
--- @param t Array<T>
--- @param callback fun(value: T, index: integer): boolean
--- @param start_at? integer
--- @return T | nil, integer | nil
function array.find_last(t, callback, start_at)
    for i = start_at or #t, 1, -1 do
        if callback(t[i], i) then
            return t[i], i
        end
    end
    return nil, nil
end


--- @generic T
--- @param s any
--- @param fn fun(string, ...): T
--- @param ... any
--- @return T
function string.pipe(s, fn, ...)
    return fn(s, ...)
end

--- @generic T
--- @param s any
--- @param fn fun(string, ...)
--- @param ... any
--- @return T
function string.peek(s, fn, ...)
    fn(s, ...)
    return s
end

--- @param s string
--- @param i integer
function string.at(s, i)
    return s:sub(i, i)
end

string.__index = function(s, k)
    if type(k) == "number" then
        return s:sub(k, k)
    end
    return string[k]
end

--- @param s string
--- @param re vim.regex | string
--- @return number | nil, number | nil
function string.match_re(s, re)
    if type(re) == "string" then
        re = vim.regex(re)
    end
    return re:match_str(s)
end

--- @param s string
--- @param sep? string
--- @param trim_empty? boolean
--- @return Array
function string.split(s, sep, trim_empty)
    sep = sep or ""
    local result = {}
    if sep == "" then
        for i = 1, #s do
            result[i] = s:sub(i, i)
        end
    else
        local idx = 1
        while true do
            local start, stop = s:find(sep, idx, true)
            if not start then
                break
            end
            if not trim_empty or idx < start then
                table.insert(result, s:sub(idx, start - 1))
            end
            idx = stop + 1
        end
        if not trim_empty or idx <= #s then
            table.insert(result, s:sub(idx, #s))
        end
    end
    return array(result)
end

--- @param s string
--- @param re string | vim.regex
--- @param trim_empty? boolean
--- @return Array
function string.split_re(s, re, trim_empty)
    re = re or ""
    if type(re) == "string" then
        re = vim.regex(re)
    end
    local result = {}
    while true and #s > 0 do
        local start, stop = re:match_str(s)
        if not start then
            break
        end
        if not trim_empty or start > 0 then
            table.insert(result, s:sub(1, start))
        end
        s = s:sub(stop + 1, #s)
    end
    if not trim_empty or #s > 0 then
        table.insert(result, s)
    end
    return array(result)
end

--- @param s string
--- @return string
function string.trim(s)
    return s:match("^%s*(.*%S)") or ""
end

--- @param s string
--- @param length integer
--- @param padChar? string
--- @return string
function string.pad_left(s, length, padChar)
    local padLength = length - #s
    if padLength > 0 then
        return (padChar or " "):rep(padLength) .. s
    else
        return s
    end
end

--- @param s string
--- @param length integer
--- @param padChar? string
--- @return string
function string.pad_right(s, length, padChar)
    local padLength = length - #s
    if padLength > 0 then
        return s .. (padChar or " "):rep(padLength)
    else
        return s
    end
end

--- @param s string
--- @param prefix string
--- @param start_at? integer
--- @return boolean
function string.starts_with(s, prefix, start_at)
    start_at = start_at or 1
    return s:sub(start_at, start_at + #prefix - 1) == prefix
end

--- @param s string
--- @param suffix string
--- @param end_at? integer
--- @return boolean
function string.ends_with(s, suffix, end_at)
    end_at = end_at or #s
    return s:sub(end_at - #suffix + 1, end_at) == suffix
end

--- @param s string
--- @param substring string
--- @return boolean
function string.contains(s, substring)
    return s:find(substring, 1, true) ~= nil
end

--- @param s string
--- @return Array
function string.bytes(s)
    return array({ string.byte(s, 1, #s) })
end

--- @param s string
--- @param start integer
--- @param stop? integer
--- @return string
function string.slice(s, start, stop)
    return s:sub(start, stop)
end

--- @param s string
--- @param substring string
--- @param start_at? integer
--- @return integer | nil
function string.index(s, substring, start_at)
    return s:find(substring, start_at or 1, true)
end

local function find_last_index_recurse(s, substring, idx, maxIdx)
    local start, stop = s:find(substring, idx, true)
    if start and stop <= maxIdx then
        local pivot = math.ceil((maxIdx - start) / 2)
        if pivot <= 1 then
            return find_last_index_recurse(s, substring, start + 1, maxIdx)
                or start
        else
            return find_last_index_recurse(s, substring, start + pivot, maxIdx)
                or find_last_index_recurse(s, substring, start + 1, maxIdx)
                or start
        end
    end
end

--- @param s string
--- @param substring string
--- @param start_at? integer
--- @return integer | nil
function string.last_index(s, substring, start_at)
    return find_last_index_recurse(s, substring, 1, start_at or #s)
end

--- @param s string
function string.surround(s, left, right)
    return left .. s .. (right or left)
end

--- @param s string
--- @param search string
--- @param replace string | fun(string, integer, integer): string
--- @param count? integer
--- @return string
function string.replace(s, search, replace, count)
    local result = {}
    local idx = 1
    count = count or math.huge
    while count > 0 do
        local start, stop = s:find(search, idx, true)
        if not start then
            break
        end
        table.insert(result, s:sub(idx, start - 1))
        local rep = replace
        if type(rep) == "function" then
            rep = rep(s:sub(start, stop), start, stop)
        end
        table.insert(result, rep)
        count = count - 1
        idx = stop + 1
    end
    table.insert(result, s:sub(idx, #s))
    return table.concat(result, "")
end

--- @param s string
--- @param re string | vim.regex
--- @param replace string | fun(string, integer, integer): string
--- @param count? integer
--- @return string
function string.replace_re(s, re, replace, count)
    if type(re) == "string" then
        re = vim.regex(re)
    end
    local result = {}
    local offset = 1
    count = count or math.huge
    while #s > 0 and count > 0 do
        local start, stop = re:match_str(s)
        if not start then
            break
        end
        table.insert(result, s:sub(1, start))
        local rep = replace
        if type(rep) == "function" then
            rep = rep(
                s:sub(start + 1, stop),
                offset + start, offset + stop)
        end
        table.insert(result, rep)
        s = s:sub(stop + 1, #s)
        offset = offset + stop
        count = count - 1
    end
    table.insert(result, s)
    return table.concat(result, "")
end

local string_mt = getmetatable("")
local string_index = string_mt.__index
function string_mt.__index(s, k)
    if type(k) == "number" then
        return string.sub(s, k, k)
    end
    return string_index[k]
end

return array
