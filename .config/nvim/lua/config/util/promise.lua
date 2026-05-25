--- @generic T
--- @class Promise<T>
local Promise = {}
Promise.__index = Promise

local new, handle, resolve, reject

--- @generic Y
--- @param callback fun(T): Y | nil
--- @return Promise<Y>
function Promise:success(callback)
    local p = new()
    handle(self, { success = callback, next = p })
    return p
end

--- @return Promise
function Promise:error(callback)
    local p = new()
    handle(self, { error = callback, next = p })
    return p
end

--- @return Promise
function Promise:finally(callback)
    local p = new()
    handle(self, { finally = callback, next = p })
    return p
end

local function is_promise(v)
    return type(v) == "table" and getmetatable(v) == Promise
end

new = function()
    return setmetatable({
        state = "pending",
        value = nil,
        queue = {},
    }, Promise)
end

handle = function(promise, handler)
    if promise.state == "pending" then
        table.insert(promise.queue, handler)
        return
    end

    if handler.finally then
        local ok, result = pcall(handler.finally)
        if not ok then
            reject(handler.next, result)
        elseif is_promise(result) then
            result
                :success(function()
                    if promise.state == "fulfilled" then
                        resolve(handler.next, promise.value)
                    else
                        reject(handler.next, promise.value)
                    end
                end)
                :error(function(r)
                    reject(handler.next, r)
                end)
        else
            if promise.state == "fulfilled" then
                resolve(handler.next, promise.value)
            else
                reject(handler.next, promise.value)
            end
        end
        return
    end

    local callback
    if promise.state == "fulfilled" then
        callback = handler.success
    else
        callback = handler.error
    end

    if not callback then
        if promise.state == "fulfilled" then
            resolve(handler.next, promise.value)
        else
            reject(handler.next, promise.value)
        end
        return
    end

    local ok, result = pcall(callback, promise.value)
    if not ok then
        reject(handler.next, result)
    else
        resolve(handler.next, result)
    end
end

resolve = function(promise, value)
    if promise.state ~= "pending" then
        return
    end
    if value == promise then
        return reject(promise, "cannot resolve promise with itself")
    end
    if is_promise(value) then
        value
            :success(function(v)
                resolve(promise, v)
            end)
            :error(function(r)
                reject(promise, r)
            end)
        return
    end
    promise.state = "fulfilled"
    promise.value = value
    for _, h in ipairs(promise.queue) do
        handle(promise, h)
    end
    promise.queue = {}
end

reject = function(promise, reason)
    if promise.state ~= "pending" then
        return
    end
    promise.state = "rejected"
    promise.value = reason
    for _, h in ipairs(promise.queue) do
        handle(promise, h)
    end
    promise.queue = {}
end

--- @return Promise
return function(executor)
    local p = new()
    executor(
        vim.schedule_wrap(function(value)
            resolve(p, value)
        end),
        vim.schedule_wrap(function(reason)
            reject(p, reason)
        end)
    )
    return p
end
