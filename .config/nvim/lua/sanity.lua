--- @diagnostic disable-next-line
sane = true

--- @diagnostic disable-next-line
table.unpack = table.unpack or unpack

local pack = function(...)
    return { n = select("#", ...), ... }
end

local unpack = function(t)
    return unpack(t, 1, t.n)
end

local TableMetatable = {}

TableMetatable.__index = table

function TableMetatable.__call(t, _, i)
    i = (i or -1) + 1
    local item = t[i + 1]
    if item then
        return i, item
    end
end

setmetatable(table, {
    __call = function(_, t)
        return setmetatable(t or {}, TableMetatable)
    end
})

--- @class tablelib
--- @field [string] any
--- @operator call: tablelib

--- @param container string | table
--- @param index number
local function wrapContainerIndex(container, index)
    return index < 0 and #container + index + 1 or index + 1
end

--- @param len number
--- @param index number
local function wrapIndex(len, index)
    return index < 0 and len + index + 1 or index + 1
end

--- @param len number
--- @param start? number
--- @param stop? number
local function indexRange(len, start, stop)
    start = start or 0
    stop = stop or len
    if start < 0 then
        start = len + start
    end
    if stop < 0 then
        stop = len + stop
    end
    start = math.max(1, start + 1)
    stop = math.min(len, stop)
    return start, stop
end

local null = vim and vim.NIL or {}

local function wrapNull(value)
    if value == nil then
        return null
    end
    return value
end

local function unwrapNull(value)
    if value == null then
        return nil
    end
    return value
end

--- @generic T
--- @param t table
--- @param fn fun(table, ...): T
--- @param ... any
--- @return T
function table._pipe(t, fn, ...)
    return fn(t, unpack(pack(...)))
end

--- @generic T
--- @param t T
--- @param fn fun(table, ...)
--- @param ... any
--- @return T
function table._peek(t, fn, ...)
    fn(t, unpack(pack(...)))
    return t
end

--- @param t table
--- @param i integer
--- @return any
function table._get(t, i)
    return unwrapNull(t[wrapContainerIndex(t, i)])
end

--- @param t table
--- @param i integer
--- @param v any
--- @return any
function table._set(t, i, v)
    t[wrapContainerIndex(t, i)] = wrapNull(v)
end

--- @generic T tablelib | table
--- @param t T
--- @param ... any
--- @return T
function table._push(t, ...)
    local args = pack(...)
    for i = 1, args.n do
        table.insert(t, wrapNull(args[i]))
    end
    return t
end

--- @generic T tablelib | table
--- @param t T
--- @param value any
--- @param idx? integer
--- @return T
function table._insert(t, value, idx)
    table.insert(
        t,
        wrapNull(value),
        idx and wrapContainerIndex(t, idx)
    )
    return t
end

--- @param t table
--- @param idx? integer
--- @return any
function table._remove(t, idx)
    return unwrapNull(table.remove(
        t,
        idx and wrapContainerIndex(t, idx)
    ))
end

--- @param t table
--- @param start? number
--- @param stop? number
--- @return tablelib
function table._slice(t, start, stop)
    local result = {}
    start, stop = indexRange(#t, start, stop)
    for i = start, stop do
        table.insert(result, t[i])
    end
    return table(result)
end

--- @param t table
--- @param start number
--- @param deleteCount number
--- @param ... any
--- @return tablelib
function table._splice(t, start, deleteCount, ...)
    local len = #t
    deleteCount = math.max(deleteCount, 0)
    start = wrapIndex(len, start)
    local newItems = table.pack(...)
    local temp = {}
    local spliced = {}
    for i = start, start + deleteCount - 1 do
        table.insert(spliced, t[i])
    end
    for i = start + deleteCount, len do
        table.insert(temp, t[i])
    end
    for i = 0, newItems.n - 1 do
        t[start + i] = wrapNull(newItems[i + 1])
    end
    start = start + newItems.n - 1
    for i = 1, #temp do
        t[start + i] = wrapNull(temp[i])
    end
    for _ = 1, len - (start + #temp) do
        table.remove(t)
    end
    return table(spliced)
end

--- @param t table
function table._unpack(t)
    for _, v in ipairs(t) do
        if v == null then
            local result = {}
            for i, v2 in ipairs(t) do
                result[i] = unwrapNull(v2)
            end
            return table.unpack(result, 1, #t)
        end
    end
    return table.unpack(t)
end

--- @param t table
--- @return table
function table._clone(t)
    return table({ table.unpack(t) })
end

--- @generic T: tablelib | table
--- @param t T
--- @param func fun(a, b): boolean
--- @return T
function table._sort(t, func)
    table.sort(t, func)
    return t
end

--- @param ... (tablelib | table)[]
--- @return table
function table._concat(...)
    local result = {}
    for _, t in ipairs({...}) do
        for _, v in ipairs(t) do
            table.insert(result, v)
        end
    end
    return table(result)
end

--- @generic T tablelib | table
--- @param t T
--- @return T
function table._clear(t)
    for i = #t, 1, -1 do
        t[i] = nil
    end
    return t
end

local function flatten(result, t, depth, maxDepth)
    if depth == maxDepth then
        for _, value in ipairs(t) do
            table.insert(result, value)
        end
    else
        for _, value in ipairs(t) do
            if type(value) == "table" then
                flatten(result, value, depth + 1, maxDepth)
            else
                table.insert(result, value)
            end
        end
    end
    return result
end

--- @param t table
--- @param depth? integer
--- @return tablelib
function table._flat(t, depth)
    return table(flatten({}, t, 0, depth or 1))
end

--- @generic T: tablelib | table
--- @param t T
--- @param callback fun(value: any, index: integer): any
--- @return tablelib
function table._filter(t, callback)
    local result = {}
    local n = 1
    for i, v in ipairs(t) do
        if callback(v, i - 1) then
            result[n] = v
            n = n + 1
        end
    end
    return table(result)
end

--- @generic T: tablelib | table
--- @param t T
--- @param callback fun(value: any): any
--- @return tablelib
function table._map(t, callback)
    local result = {}
    for i, v in ipairs(t) do
        result[i] = wrapNull(callback(unwrapNull(v)))
    end
    return table(result)
end

--- @generic T
--- @param t table
--- @param reducer fun(acc: any, value: any): T
--- @param initialValue? any
--- @return T
function table._reduce(t, reducer, initialValue)
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

--- @generic T tablelib | table
--- @param t T
--- @param callback fun(value: any)
--- @return T
function table._each(t, callback)
    for _, v in ipairs(t) do
        callback(unwrapNull(v))
    end
    return t
end

--- @param t table
--- @param sep string
--- @return string
function table._join(t, sep)
    return table.concat(t, sep or "")
end

--- @param t table
--- @return tablelib
function table._keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return table(keys)
end

--- @param t table
--- @return tablelib
function table._values(t)
    local values = {}
    for _, v in pairs(t) do
        table.insert(values, v)
    end
    return table(values)
end

--- @param t table
--- @return tablelib
function table._entries(t)
    local entries = {}
    for k, v in pairs(t) do
        table.insert(entries, table { k, v })
    end
    return table(entries)
end

--- @param ... table
--- @return tablelib
function table._spread(...)
    local result = {}
    for _, t in ipairs({...}) do
        for k, v in pairs(t) do
            result[k] = v
        end
    end
    return table(result)
end

--- @param t table
--- @return tablelib
function table._toObject(t)
    local result = {}
    for entry in ipairs(t) do
        if type(entry[1]) == "number" then
            result[entry[1]] = wrapNull(entry[2])
        else
            result[entry[1]] = unwrapNull(entry[2])
        end
    end
    return table(result)
end

--- @param t table
--- @param element any
--- @return boolean
function table._contains(t, element)
    for _, v in ipairs(t) do
        if v == element then
            return true
        end
    end
    return false
end

--- @param t table
--- @param element any
--- @param startAt? integer
--- @return integer | nil
function table._index(t, element, startAt)
    local len = #t
    for i = wrapIndex(len, startAt or 0), len do
        if t[i] == element then
            return i - 1
        end
    end
    return nil
end

--- @param t table
--- @param element any
--- @param startAt? integer
--- @return integer | nil
function table._lastIndex(t, element, startAt)
    local len = #t
    for i = wrapIndex(len, startAt or len - 1), 0, -1 do
        if t[i] == element then
            return i - 1
        end
    end
    return nil
end

--- @param t table
--- @param callback fun(value: any, index: integer): any
--- @param startAt? integer
--- @return any, integer | nil
function table._find(t, callback, startAt)
    local len = #t
    for i = wrapIndex(len, startAt or 0), len do
        if callback(t[i], i - 1) then
            return i - 1
        end
    end
    return nil
end

--- @param t table
--- @param callback fun(value: any, index: integer): any
--- @param startAt? integer
--- @return any, integer | nil
function table._findLast(t, callback, startAt)
    local len = #t
    for i = wrapIndex(len, startAt or len - 1), 0, -1 do
        if callback(t[i], i - 1) then
            return t[i], i
        end
    end
    return nil, nil
end


--- @generic T
--- @param s string
--- @param fn fun(string, ...): T
--- @param ... any
--- @return T
function string._pipe(s, fn, ...)
    return fn(s, unpack(pack(...)))
end

--- @param s string
--- @param fn fun(string, ...)
--- @param ... any
--- @return string
function string._peek(s, fn, ...)
    fn(s, unpack(pack(...)))
    return s
end

--- @param s string
--- @param i integer
function string._get(s, i)
    i = wrapContainerIndex(s, i)
    return s:sub(i, i)
end

--- @param s string
--- @param sep? string
--- @return table
function string._split(s, sep)
    sep = sep or ""
    local result = {}
    if sep == "" then
        for match in (s .. sep):gmatch(".") do
            table.insert(result, match)
        end
    else
        for match in (s .. sep):gmatch("(.-)" .. sep) do
            table.insert(result, match)
        end
    end
    return table(result)
end

string._upper = string.upper
string._lower = string.lower

--- @param s string
--- @return string
function string._trim(s)
    return s:match("^%s*(.*%S)") or ""
end

--- @param s string
--- @param length integer
--- @param padChar string
--- @return string
function string._padLeft(s, length, padChar)
    local padLength = length - #s
    if padLength > 0 then
        return padChar:rep(padLength) .. s
    else
        return s
    end
end

--- @param s string
--- @param length integer
--- @param padChar string
--- @return string
function string._padRight(s, length, padChar)
    local padLength = length - #s
    if padLength > 0 then
        return s .. padChar:rep(padLength)
    else
        return s
    end
end

--- @param s string
--- @param substring string
--- @return boolean
function string._contains(s, substring)
    return s:find(substring, 1, true) ~= nil
end

--- @param s string
--- @param index? integer
--- @return integer
function string._byte(s, index)
    return string.byte(s, wrapContainerIndex(s, index or 0))
end

--- @param s string
--- @return table
function string._bytes(s)
    return table({ string.byte(s, 1, #s) })
end

--- @param s string
--- @param start? integer
--- @param stop? integer
--- @return string
function string._slice(s, start, stop)
    start, stop = indexRange(#s, start, stop)
    return s:sub(start, stop)
end

--- @param s string
--- @param substring string
--- @param startAt? integer
--- @return integer | nil
function string._index(s, substring, startAt)
    local _, index = s:find(
        substring,
        wrapContainerIndex(s, startAt or 0),
        true
    )
    if not index then
        return nil
    end
    return index - 1
end

--- @param s string
--- @param substring string
--- @param startAt? integer
--- @return integer | nil
function string._lastIndex(s, substring, startAt)
    local index = nil
    substring = substring
    local len = #s
    local i = wrapIndex(len, startAt or len - 1) - #substring + 1
    while i > 0 do
        local start = s:find(substring, i, true)
        if start then
            return start - 1
        end
        i = i - #substring
    end
    return index
end

--- @param s string
function string._surround(s, left, right)
    return left .. s .. right or left
end

--- @param s string
function string._replace(s, search, replace)
    local result, _ = s:gsub(search, replace)
    return result
end
