require "sanity"

vim.o.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"
vim.o.undolevels = 200
vim.o.undofile = true

if vim.o.undodir
    :_pipe(vim.fn.expand)
    :_pipe(vim.fn.isdirectory) == 0
then
    vim.o.undodir
        :_pipe(vim.fn.expand)
        :_pipe(vim.fn.mkdir, "p", 770)
end
