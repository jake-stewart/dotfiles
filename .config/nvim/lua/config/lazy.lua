local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.loop.fs_stat(lazypath)) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("config.plugins", {
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
                "zipPlugin"
            }
        }
    }
})
