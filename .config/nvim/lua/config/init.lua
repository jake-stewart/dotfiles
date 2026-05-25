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
        local command = {
            "git",
            "clone",
            "--filter=blob:none",
            repo,
            path
        }
        if opts.branch then
            table.insert(command, "--branch=" .. (opts.branch or "stable"))
        end
        local out = vim.fn.system(command)
        if vim.v.shell_error ~= 0 then
            echo("Failed to clone " .. name .. ":", "Error")
            echo(out)
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.runtimepath:prepend(path)
end

-- bootstrap("folke", "lazy", { branch = "stable" })
bootstrap("jake-stewart", "lazier", {
    dir = "/Users/jakey/clones/lazier.nvim",
    -- branch = "stable-v2"
    -- branch = "main"
})

require("lazier").setup("config.plugins", {
    lazier = {
        enabled = true,
        before = function()
            require "config.options"
            require "config.colors"
            local undo = require("config.undo")
            undo.setup()
        end,
        after = function()
            require "config.autocommands"
            require "config.ignore"
            require "config.mappings"
            require "config.util.synstack"
        end,
        -- compile_api = true,
        generate_lazy_mappings = true,
        detect_changes = false,
        start_lazily = function()
            if _G["nvimpager"] then
                return false
            end
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
            reset = true,
            disabled_plugins = {
                "2html_plugin",
                "tohtml",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                -- "netrw",
                -- "netrwPlugin",
                -- "netrwSettings",
                -- "netrwFileHandlers",
                "matchit",
                "tar",
                "tutor",
                "tarPlugin",
                "rrhelper",
                "spellfile_plugin",
                "vimball",
                "vimballPlugin",
                -- "zip",
                -- "zipPlugin",
                "rplugin",
                "syntax",
                "synmenu",
                "optwin",
                "compiler",
                "bugreport",
                "ftplugin",
            }
        }
    }
})
