local tsnvim_path = vim.fn.stdpath("data") .. "/ts.nvim"
if not vim.loop.fs_stat(tsnvim_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/jake-stewart/ts.nvim.git",
        -- "--branch=stable",
        tsnvim_path,
    })
end
vim.opt.rtp:prepend(tsnvim_path)
require("tsnvim").setup()
