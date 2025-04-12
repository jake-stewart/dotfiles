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

bootstrap("jake-stewart", "lazier", {
    -- dir = "/Users/jakey/clones/lazier.nvim"
})
bootstrap("folke", "lazy")

require("lazier").setup("config.plugins", {
    lazier = {
        before = function()
            vim.loader.enable()
            require "config.options"
            require "config.autocommands"
            require "config.colors"
        end,
        after = function()
            require "config.ignore"
            require "config.mappings"
            require "config.undo"
        end,
        detect_changes = false,
        start_lazily = function()
            local fname = vim.fn.expand("%")
            return fname == ""
                or vim.fn.isdirectory(fname) == 0
                and not ({
                    zip = true,
                    tar = true,
                    gz = true,
                    md = true
                })[vim.fn.fnamemodify(fname, ":e")]
        end
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
                "tohtml",
                "tutor",
            }
        }
    }
})
