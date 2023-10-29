vim.api.nvim_create_augroup("NvimCustomAutocommands", {clear=true})

-- vim.api.nvim_create_user_command(
--     "Ex",
--     function()
--         if vim.bo.modified then
--             print("First save your file")
--         else
--             vim.cmd("Explore")
--         end
--     end,
--     {}
-- )

-- remove auto commenting
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = "NvimCustomAutocommands",
    callback = function()
        local fo = vim.bo.fo
        fo = fo:gsub("c", "")
        fo = fo:gsub("r", "")
        fo = fo:gsub("o", "")
        vim.bo.fo = fo
        -- print("hi", vim.bo.fo)
    end
})

-- -- remove line numbers in terminal & start insert
-- vim.api.nvim_create_autocmd("TermOpen", {
--     pattern = "*",
--     group = "NvimCustomAutocommands",
--     callback = function()
--         vim.opt_local.number = false
--         vim.cmd.startinsert()
--     end
-- })
-- 
-- vim.api.nvim_create_autocmd("TermClose", {
--     pattern = "*",
--     group = "NvimCustomAutocommands",
--     callback = function()
--         vim.cmd.close()
--     end
-- })

-- restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
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
vim.api.nvim_create_autocmd("FileType", {
    pattern = "c,cpp,cs,java,php",
    group = "NvimCustomAutocommands",
    callback = function()
        vim.cmd.setlocal("commentstring=//\\ %s")
    end
})

-- tablescript
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.tbl",
    group = "NvimCustomAutocommands",
    callback = function()
        vim.cmd.setf("tablescript")
    end
})
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.tbl",
    group = "NvimCustomAutocommands",
    callback = function()
        vim.cmd.setf("tablescript")
    end
})
