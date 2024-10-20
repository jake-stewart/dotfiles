local ascii_a = string._byte("a")
local ascii_z = string._byte("z")
local ascii_A = string._byte("A")
local ascii_Z = string._byte("Z")

local function islower(c)
    return ascii_a <= c and c <= ascii_z
end

local function isupper(c)
    return ascii_A <= c and c <= ascii_Z
end

return function(text, numbers)
    if numbers == nil then
        numbers = false
    end
    local results = {}
    local idx = 0
    local size = 0
    local upper = false
    for c in text:bytes() do
        if islower(c) then
            if upper and size > 1 then
                results:push(text:slice(idx, idx + size - 1))
                idx = idx + (size - 1)
                size = 1
            end
            size = size + 1
            upper = false
        elseif isupper(c) then
            if not upper and size > 1 then
                results:push(text:slice(idx, idx + size))
                idx = idx + size
                size = 0
            end
            size = size + 1
            upper = true
        else
            if size > 0 then
                results:push(text:slice(idx, idx + size))
                idx = idx + size
                size = 0
            end
            idx = idx + 1
        end
    end
    if size > 0 then
        results:push(text:slice(idx, idx + size))
    end
    return results
end
