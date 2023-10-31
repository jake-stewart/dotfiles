local function getPopups()
    return vim.fn.filter(vim.api.nvim_tabpage_list_wins(0),
        function(_, e) return vim.api.nvim_win_get_config(e).zindex end)
end

local function popupOpen()
    return #getPopups() > 0
end

local function jumpToDiagnostic(direction)
    local floatOpts = {
        format = function(diagnostic)
            return vim.split(diagnostic.message, "\n")[1]
        end,
        -- source = true,
        prefix = "",
        suffix = "",
        focusable = false,
        header = ""
    }
    local action = direction == 1 and "goto_next" or "goto_prev"
    if popupOpen() then
        vim.diagnostic[action]({ float = floatOpts })
    else
        vim.diagnostic[action]({
            float = floatOpts,
            cursor_position = {
                vim.fn.line("."),
                direction == 1 and 0 or 9999
            }
        })
    end
end

return {
    'neovim/nvim-lspconfig',
    dependencies = { 'hrsh7th/nvim-cmp' },
    ft = {
        "c",
        "cpp",
        "java",
        "python",
        "typescript",
        "typescriptreact",
        "javascript",
        -- "cs",
        "php",
        "blade",
        "lua",
    },
    config = function()
        local success, result = pcall(function()
            return require('cmp_nvim_lsp').default_capabilities()
        end)
        local capabilities = success and result or {}
        if (success) then
            capabilities.textDocument.completion.completionItem.snippetSupport = false
        end

        local on_attach = function(client, bufnr, opts)
            client.server_capabilities.semanticTokensProvider = nil;
            local bufopts = { remap = false, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<c-r>', vim.cmd.LspRestart, bufopts)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', '<up>', function() jumpToDiagnostic(-1) end, bufopts)
            vim.keymap.set('n', '<down>', function() jumpToDiagnostic(1) end, bufopts)
            vim.keymap.set('n', 'g<up>', function()
                vim.diagnostic.open_float({focusable = false})
            end, bufopts)
            -- vim.diagnostic.open_float(nil, { focusable = false })
            if opts.commentstring then
                vim.cmd.setlocal("commentstring=" .. opts.commentstring)
            end
        end

        local function setup(server, opts)
            require('lspconfig')[server].setup({
                capabilities = capabilities,
                inlay_hints = { enabled = false },
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr, opts)
                end,
                settings = {
                    Lua = {
                        diagnostics = { globals = {'vim'} }
                    }
                }
            })
        end

        local cStyleComment = { commentstring = "//\\ %s" }
        setup("clangd", cStyleComment)
        setup("jdtls", cStyleComment)
        setup("tsserver", cStyleComment)
        setup("intelephense", cStyleComment)
        -- setup("csharp_ls", cStyleComment)
        setup("lua_ls", {
        })
        setup("pyright", {})
    end,
}
