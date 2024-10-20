require "sanity"

--- @diagnostic disable-next-line
table.unpack = table.unpack or unpack

--- @class PluginBuilder
--- @field private _repo string
--- @field private _dir? string
--- @field private _branch? string
--- @field private _commit? string
--- @field private _keys? tablelib
--- @field private _highlights? table
--- @field private _ft? tablelib
--- @field private _cmd? tablelib
--- @field private _deps? tablelib
--- @field private _event? tablelib
--- @field private _moduleNames? tablelib
--- @field private _modules? tablelib
--- @field private _enabled? boolean
--- @field private _lazy? boolean
--- @field private _init? function
local PluginBuilder = {}
PluginBuilder.__index = PluginBuilder

--- @param dir string
--- @return self
function PluginBuilder:dir(dir)
    self._dir = dir
    return self
end

--- @param branch string
--- @return self
function PluginBuilder:branch(branch)
    self._branch = branch
    return self
end

--- @param commit string
--- @return self
function PluginBuilder:commit(commit)
    self._commit = commit
    return self
end

--- @return self
function PluginBuilder:disable()
    self._enabled = false
    return self
end

--- @param value boolean
--- @return self
function PluginBuilder:lazy(value)
    self._lazy = value
    return self
end

--- @param ... string
--- @return self
function PluginBuilder:deps(...)
    self._deps = table { ... }
    return self
end

--- @param ... string | string[]
--- @return self
function PluginBuilder:ft(...)
    self._ft = table({...}):_flat()
    return self
end

--- @param ... string
--- @return self
function PluginBuilder:cmd(...)
    self._cmd = table { ... }
    return self
end

--- @param mode string | string[]
--- @param from string
--- @param to? string | function
--- @param opts? table
--- @return self
function PluginBuilder:map(mode, from, to, opts)
    opts = table(opts or {})
    opts.mode = mode
    opts:_push(from)
    if to then
        opts:_push(to)
    end
    self._keys:_push(opts)
    return self
end

--- @param name string
--- @param opts table
--- @return self
function PluginBuilder:hl(name, opts)
    self._highlights = self._highlights or {}
    self._highlights[name] = opts
    return self
end

--- @param ... string
--- @return self
function PluginBuilder:event(...)
    self._event = table { ... }
    return self
end

--- @param ... string
--- @return self
function PluginBuilder:module(...)
    self._moduleNames = table { ... }
    return self
end

--- @param callback function
--- @return self
function PluginBuilder:init(callback)
    self._init = callback
    return self
end

--- @param callbackOrOpts? function | table
--- @return table
function PluginBuilder:setup(callbackOrOpts)
    if self._init then
        self._init()
    end
    local config = function()
        if self._highlights then
            for k, v in pairs(self._highlights) do
                vim.api.nvim_set_hl(0, k, v)
            end
        end
        self._modules = table()
        if self._moduleNames then
            for i, v in self._moduleNames do
                self._modules:_set(i, require(v))
            end
        end
        if type(callbackOrOpts) == "function" then
            callbackOrOpts(table.unpack(self._modules))
        elseif type(callbackOrOpts) == "table" then
            self._modules:_get(0).setup(callbackOrOpts)
        end
    end

    if self._keys then
        for _, v in self._keys do
            v = table(v)
            local callback = v:_get(1)
            if type(callback) == "function" then
                v:_set(1, function()
                    return callback(table.unpack(self._modules))
                end)
            end
        end
    end
    return {
        self._repo,
        lazy = self._lazy,
        dependencies = self._deps,
        ft = self._ft,
        cmd = self._cmd,
        event = self._event,
        dir = self._dir,
        branch = self._branch,
        commit = self._commit,
        enabled = self._enabled,
        config = config,
        keys = self._keys
    }
end

--- @class PluginConstructor
--- @operator call: PluginBuilder
--- @field [string] function
local plugin = {}

setmetatable(plugin, plugin)

--- @param repo string
--- @return PluginBuilder
function plugin.__call(_, repo)
    return setmetatable({
        _repo = repo,
        _keys = table(),
        _modules = table(),
    }, PluginBuilder)
end

function plugin.__index(_, k)
    return function(...)
        local args = { n = select("#", ...), ... }
        return function(module)
            return module[k](table.unpack(args, 1, args.n))
        end
    end
end

return plugin
