return {
    "jake-stewart/filestack.vim",
    keys = {
        { "<m-o>", function()
            vim.fn.FilestackBack()
            vim.cmd.norm("zz")
        end },
        { "<m-i>", function()
            vim.fn.FilestackForward()
            vim.cmd.norm("zz")
        end },
        -- { "<c-p>", function()
        --     vim.fn.FilestackAlternateFile()
        --     vim.cmd.norm("zz")
        -- end },
    },
}
