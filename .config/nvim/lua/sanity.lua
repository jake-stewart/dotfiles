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

local TableMetatable = {}

TableMetatable.__index = table

function TableMetatable.__call(t, _, i)
    i = (i or 0) + 1
    local item = t[i]
    if item then
        return i, item
    end
end

setmetatable(table, {
    __call = function(_, t)
        return setmetatable(t or {}, TableMetatable)
    end
})

--- @param container string | table
--- @param index number
local function wrapContainerIndex(container, index)
    return index < 0 and #container + index + 1 or index
end

--- @param len number
--- @param index number
local function wrapIndex(len, index)
    return index < 0 and len + index + 1 or index
end

--- @param len number
--- @param start? number
--- @param stop? number
local function indexRange(len, start, stop)
    start = start or 1
    stop = stop or len
    if start < 0 then
        start = len + start + 1
    end
    if stop < 0 then
        stop = len + stop + 1
    end
    start = math.max(1, start)
    stop = math.min(len, stop)
    return start, stop
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
function table._at(t, i)
    return t[wrapContainerIndex(t, i)]
end

--- @param t table
--- @param k any
--- @param default any
--- @return any
function table._get(t, k, default)
    local item = t[k]
    if item == nil then
        t[k] = default
        return default
    end
    return item
end

--- @generic T Table | table
--- @param t T
--- @param ... any
--- @return T
function table._push(t, ...)
    local args = pack(...)
    for i = 1, args.n do
        table.insert(t, args[i])
    end
    return t
end

--- @generic T Table | table
--- @param t T
--- @param value any
--- @param idx? integer
--- @return T
function table._insert(t, value, idx)
    table.insert(
        t,
        value,
        idx and wrapContainerIndex(t, idx)
    )
    return t
end

--- @param t table
--- @param idx? integer
--- @return any
function table._remove(t, idx)
    return table.remove(
        t,
        idx and wrapContainerIndex(t, idx)
    )
end

--- @param t table
--- @param start? number
--- @param stop? number
--- @return Table
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
--- @return Table
function table._splice(t, start, deleteCount, ...)
    local newItems = { ... }
    deleteCount = math.max(0, deleteCount)
    start = wrapIndex(#t, start)
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
    return table(spliced)
end

--- @param t table
function table._unpack(t)
    return table.unpack(t)
end

--- @param t table
--- @return Table
function table._clone(t)
    local result = {}
    for k, v in pairs(t) do
        result[k] = v
    end
    return table(result)
end

--- @generic T: Table | table
--- @param t T
--- @param func fun(a, b): boolean
--- @return T
function table._sort(t, func)
    table.sort(t, func)
    return t
end

--- @generic T: Table | table
--- @param t T
--- @return T
function table._reverse(t)
    local i = 1
    local j = #t
    while i < j do
        t[i], t[j] = t[j], t[i]
        i = i + 1
        j = j - 1
    end
    return t
end

--- @param t table
--- @return Table
function table._uniq(t)
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
    return table(result)
end

--- @param ... (Table | table)[]
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

--- @generic T Table | table
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

--- @param t table
--- @param depth? integer
--- @return Table
function table._flat(t, depth)
    return table(flatten({}, t, 0, depth or 1))
end

--- @generic T: Table | table
--- @param t T
--- @param callback fun(value: any, k: any): any
--- @return Table
function table._filter(t, callback)
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
    return table(result)
end

--- @generic T: Table | table
--- @param t T
--- @param callback fun(value: any, k: any): any
--- @return Table
function table._map(t, callback)
    local result = {}
    for k, v in pairs(t) do
        result[k] = callback(v, k)
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

--- @generic T Table | table
--- @param t T
--- @param callback fun(value: any, k: any)
--- @return T
function table._each(t, callback)
    for k, v in pairs(t) do
        callback(v, k)
    end
    return t
end

--- @generic T Table | table
--- @param t T
--- @param callback fun(value: any, k: any): boolean | nil
--- @return boolean
function table._any(t, callback)
    for k, v in pairs(t) do
        if callback(v, k) then
            return true
        end
    end
    return false
end

--- @generic T Table | table
--- @param t T
--- @param callback fun(value: any, k: any): boolean | nil
--- @return boolean
function table._all(t, callback)
    for k, v in pairs(t) do
        if not callback(v, k) then
            return false
        end
    end
    return true
end

--- @param t table
--- @param sep string
--- @return string
function table._join(t, sep)
    return table.concat(t, sep or "")
end

--- @param t table
--- @return Table
function table._keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return table(keys)
end

--- @param t table
--- @return Table
function table._values(t)
    local values = {}
    for _, v in pairs(t) do
        table.insert(values, v)
    end
    return table(values)
end

--- @param t table
--- @return Table
function table._entries(t)
    local entries = {}
    for k, v in pairs(t) do
        table.insert(entries, table { k, v })
    end
    return table(entries)
end

--- @param ... table
--- @return Table
function table._spread(...)
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
            return i
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
    for i = wrapIndex(len, startAt or len), 1, -1 do
        if t[i] == element then
            return i
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
    for i = wrapIndex(len, startAt or 1), len do
        if callback(t[i], i) then
            return t[i], i
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
    for i = wrapIndex(len, startAt or len), 1, -1 do
        if callback(t[i], i) then
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
function string._at(s, i)
    i = wrapContainerIndex(s, i)
    return s:sub(i, i)
end

--- @param s string
--- @param sep string
--- @param trimEmpty? boolean
--- @return Table
local function stringSplit(s, sep, trimEmpty)
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
            if not trimEmpty or idx < start then
                table.insert(result, s:sub(idx, start - 1))
            end
            idx = stop + 1
        end
        if not trimEmpty or idx <= #s then
            table.insert(result, s:sub(idx, #s))
        end
    end
    return table(result)
end

--- @param s string
--- @param re vim.regex | string
--- @return number | nil, number | nil
function string._match(s, re)
    if type(re) == "string" then
        re = vim.regex(re)
    end
    return re:match_str(s)
end

--- @param s string
--- @param re vim.regex
--- @param trimEmpty? boolean
--- @return Table
local function regexSplit(s, re, trimEmpty)
    local result = {}
    while true and #s > 0 do
        local start, stop = re:match_str(s)
        if not start then
            break
        end
        if not trimEmpty or start > 0 then
            table.insert(result, s:sub(1, start))
        end
        s = s:sub(stop + 1, #s)
    end
    if not trimEmpty or #s > 0 then
        table.insert(result, s)
    end
    return table(result)
end

--- @param s string
--- @param sep? string | vim.regex
--- @param trimEmpty? boolean
--- @return Table
function string._split(s, sep, trimEmpty)
    sep = sep or ""
    if type(sep) == "string" then
        return stringSplit(s, sep, trimEmpty)
    else
        return regexSplit(s, sep, trimEmpty)
    end
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
        return (padChar or " "):rep(padLength) .. s
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
        return s .. (padChar or " "):rep(padLength)
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
    return s:find(
        substring,
        wrapContainerIndex(s, startAt or 1),
        true
    )
end

local function findLastIndexRecurse(s, substring, idx, maxIdx)
    local start, stop = s:find(substring, idx, true)
    if start and stop <= maxIdx then
        local pivot = math.ceil((maxIdx - start) / 2)
        if pivot <= 1 then
            return findLastIndexRecurse(s, substring, start + 1, maxIdx)
                or start
        else
            return findLastIndexRecurse(s, substring, start + pivot, maxIdx)
                or findLastIndexRecurse(s, substring, start + 1, maxIdx)
                or start
        end
    end
end

--- @param s string
--- @param substring string
--- @param startAt? integer
--- @return integer | nil
function string._lastIndex(s, substring, startAt)
    return findLastIndexRecurse(s, substring, 1, wrapContainerIndex(s, startAt or -1))
end

--- @param s string
function string._surround(s, left, right)
    return left .. s .. right or left
end

--- @param s string
--- @param re vim.regex
--- @param replacer fun(integer, integer): string
--- @param count number
--- @return string
local function regexReplace(s, re, replacer, count)
    local result = {}
    local offset = 1
    while #s > 0 and count > 0 do
        local start, stop = re:match_str(s)
        if not start then
            break
        end
        table.insert(result, s:sub(1, start))
        table.insert(result,
            replacer(offset + start, offset + stop - 1))
        s = s:sub(stop + 1, #s)
        offset = offset + stop
        count = count - 1
    end
    table.insert(result, s)
    return table.concat(result, "")
end

--- @param s string
--- @param search string
--- @param replacer function(integer, integer): string
--- @param count number
--- @return string
local function stringReplace(s, search, replacer, count)
    local result = {}
    local idx = 1
    while count > 0 do
        local start, stop = s:find(search, idx, true)
        if not start then
            break
        end
        table.insert(result, s:sub(idx, start - 1))
        table.insert(result, replacer(start, stop))
        count = count - 1
        idx = stop + 1
    end
    table.insert(result, s:sub(idx, #s))
    return table.concat(result, "")
end

--- @param s string
--- @param search string | vim.regex
--- @param replace string | fun(string, integer): string
--- @param count? integer
--- @return string
function string._replace(s, search, replace, count)
    local replacer = type(replace) == "function"
        and function(start, stop)
            return replace(s:sub(start, stop), start)
        end
        or function()
            return replace
        end
    if type(search) == "string" then
        return stringReplace(s, search, replacer, count or math.huge)
    else
        return regexReplace(s, search, replacer, count or math.huge)
    end
end

--- @class Table : tablelib, table
--- @field [string] any

--- @class tablelib
--- @operator call: Table
