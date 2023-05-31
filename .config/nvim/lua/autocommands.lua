local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("NvimCustomAutocommands", {clear=true})

-- remove auto commenting
autocmd("FileType", {
    pattern = "*",
    group = "NvimCustomAutocommands",
    callback = function()
        vim.cmd [[ setlocal fo-=c fo-=r fo-=o ]]
    end
})

-- restore cursor position
autocmd("BufReadPost", {
    pattern = "*",
    group = "NvimCustomAutocommands",
    callback = function()
    vim.cmd [[
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal g'\""
            call feedkeys("zz")
        endif
    ]]
    end
})

-- comment string
autocmd("FileType", {
    pattern = "c,cpp,cs,java,php",
    group = "NvimCustomAutocommands",
    callback = function()
        vim.cmd [[ setlocal commentstring=//\ %s ]]
    end
})

-- tablescript
autocmd("BufNewFile", {
    pattern = "*.tbl",
    group = "NvimCustomAutocommands",
    callback = function()
        vim.cmd [[ setf tablescript ]]
    end
})
autocmd("BufRead", {
    pattern = "*.tbl",
    group = "NvimCustomAutocommands",
    callback = function()
        vim.cmd [[ setf tablescript ]]
    end
})
