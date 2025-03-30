require "sanity"
require "config.options"
require "config.autocommands"
require "config.colors"

local function echo(message, hl)
    vim.api.nvim_echo({{ message, hl or "Normal" }}, true, {})
end

local function bootstrap(author, name, opts)
    opts = opts or {}
    local path = opts.dir or (
        vim.fn.stdpath("data") .. "/" .. name .. "/" .. name .. ".nvim"
    )
    if not vim.uv.fs_stat(path) then
        local repo = "https://github.com/" .. author .. "/" .. name .. ".nvim"
        local out = vim.fn.system({
            "git",
            "clone",
            "--branch=" .. (opts.branch or "stable"),
            "--filter=blob:none",
            repo,
            path
        })
        if vim.v.shell_error ~= 0 then
            echo("Failed to clone " .. name .. ":", "Error")
            echo(out)
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.runtimepath:prepend(path)
end

bootstrap("jake-stewart", "lazier")
bootstrap("folke", "lazy")

require("lazier").setup("config.plugins", {
    lazier = {
        after = function()
            require "config.mappings"
        end,
    },
    install = {
        colorscheme = { "custom" }
    },
    defaults = { lazy = true },
    change_detection = {
        enabled = false,
        notify = false
    },
    performance = {
        cache = { enabled = true },
        reset_packpath = true,
        rtp = {
            reset = false,
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                -- "zipPlugin"
            }
        }
    }
})
