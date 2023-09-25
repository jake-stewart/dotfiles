return {
    'neovim/nvim-lspconfig',
    dependencies = { 'hrsh7th/nvim-cmp' },
    ft = {
        -- "cs",
        "cpp",
        "java",
        "python",
        "typescript",
        "typescriptreact",
        "javascript",
        "php",
        "blade",
        "lua",
    },
    config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = false

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
            vim.keymap.set('n', '<c-k>', function()
                vim.diagnostic.open_float(nil, { focusable = false })
            end, bufopts)

            if opts.commentstring then
                vim.cmd.setlocal("commentstring=" .. opts.commentstring)
            end
        end

        local function setup(server, opts)
            require('lspconfig')[server].setup({
                capabilities = capabilities,
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
        setup("lua_ls", {})
        setup("pyright", {})
    end,
}
