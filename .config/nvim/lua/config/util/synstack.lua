vim.api.nvim_create_user_command("SynStack", function()
    if vim.fn.exists("*synstack") == 0 then
        return
    end
    local stack = vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.'))
    local attrs = vim.tbl_map(function(val)
        return vim.fn.synIDattr(val, "name")
    end, stack)
    vim.print(table.concat(attrs, ", "))
end, {})
