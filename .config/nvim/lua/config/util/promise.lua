require "sanity"

local PromiseMetatable = {}
PromiseMetatable.__index = PromiseMetatable

function PromiseMetatable:success(callback)
    if self.state == "pending" then
        self.callbacks:_push(callback)
    elseif self.state == "fulfilled" then
        callback(self.value)
    end
    return self
end

function PromiseMetatable:error(callback)
    if self.state == "rejected" then
        callback(self.value)
    else
        self.errorCallbacks:_push(callback)
    end
    return self
end

function PromiseMetatable:finally(callback)
    if self.state ~= "pending" then
        callback()
    end
    self.finallyCallbacks:_push(callback)
    return self
end

local function Promise(executor)
    local promise = setmetatable({}, PromiseMetatable)
    promise.callbacks = table {}
    promise.errorCallbacks = table {}
    promise.finallyCallbacks = table {}
    promise.state = "pending"
    promise.value = nil

    local function resolve(value)
        if promise.state == "pending" then
            promise.state = "fulfilled"
            promise.value = value
            for _, callback in promise.callbacks do
                callback(value)
            end
            for _, callback in promise.finallyCallbacks do
                callback()
            end
        end
    end

    local function reject(reason)
        if promise.state == "pending" then
            promise.state = "rejected"
            promise.value = reason
            for _, callback in promise.errorCallbacks do
                callback(reason)
            end
            for _, callback in promise.finallyCallbacks do
                callback()
            end
        end
    end

    local success, err = pcall(executor, resolve, reject)
    if not success then
        reject(err)
    end

    return promise
end

return Promise
