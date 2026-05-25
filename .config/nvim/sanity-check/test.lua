require "sanity"

local function inspect(s)
    if type(s) == "function" then
        return "<f>"
    elseif type(s) == "string" then
        return '"' .. s:replace('"', '\\"') .. '"'
    elseif type(s) == "table" then
        return vim.inspect(setmetatable(vim.deepcopy(s), nil))
            :split("\n")
            :map(function (line) return line:trim() end)
            :join(" ")
    else
        return tostring(s)
    end
end

local test = {
    numTests = 0,
    numPasses = 0,
    numFails = 0,
}
setmetatable(test, test)

function test.__call(t, opts)
    t.numTests = t.numTests + 1
    local inputRepr = inspect(opts.item)
    local title =
        "(" .. inputRepr .. "):"
        .. opts.method
        .. "(" .. array(opts.args):map(inspect):join(", ") .. ")"

    local success, ret = pcall(function()
        return opts.item[opts.method](opts.item, table.unpack(opts.args))
    end)
    if not success then
        t.numFails = t.numFails + 1
        vim.print("[FAIL] " .. title)
        vim.print("       error: " .. ret)
        return
    end

    if
        opts.expectedReturn
        and not vim.deep_equal(ret, opts.expectedReturn)
        or opts.expectedItem
        and not vim.deep_equal(opts.item, opts.expectedItem)
    then
        t.numFails = t.numFails + 1
        vim.print("[FAIL] " .. title)
        vim.print("       input:           " .. inputRepr)
        vim.print("       expected return: " .. inspect(opts.expectedReturn))
        vim.print("       actual return:   " .. inspect(ret))
        vim.print("       expected value:  " .. inspect(opts.expectedItem))
        vim.print("       actual value:    " .. inspect(opts.item))
    else
        t.numPasses = t.numPasses + 1
        vim.print("[PASS] " .. title)
    end
end

return test

