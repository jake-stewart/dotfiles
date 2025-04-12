local ignored = {
    ["Defining diagnostic signs with :sign-define or sign_define()"] = true
}

local deprecate = vim.deprecate

--- @diagnostic disable-next-line
function vim.deprecate(name, ...)
    if not ignored[name] then
        deprecate(name, ...)
    end
end
