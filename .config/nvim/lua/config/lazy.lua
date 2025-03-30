local function echo(message, hl)
    vim.api.nvim_echo({{ message, hl or "Normal" }}, true, {})
end

local function bootstrap(repo, path, overridePath)
    path = vim.fn.stdpath("data") .. path
    if not vim.uv.fs_stat(overridePath or path) then
        repo = "https://github.com/" .. repo
        local out = vim.fn.system({
            "git",
            "clone",
            "--branch=stable",
            "--filter=blob:none",
            repo,
            path
        })
        if vim.v.shell_error ~= 0 then
            echo("Failed to clone " .. repo .. ":", "Error")
            echo(out)
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.runtimepath:prepend(overridePath or path)
end

bootstrap("jake-stewart/lazier.nvim", "/lazier.nvim", "/Users/jakey/clones/lazier.nvim")
bootstrap("folke/lazy.nvim", "/lazy/lazy.nvim")

require("lazier.setup")("config.plugins", {
    after_lazy = function()
        require "config.mappings"
    end,
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
