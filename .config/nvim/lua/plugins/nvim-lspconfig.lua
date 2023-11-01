local function minMax(table, callback)
    callback = callback or function (e) return e end
    local min = nil
    local max = nil
    for _, item in ipairs(table) do
        min = math.min(min or math.huge, callback(item))
        max = math.max(max or -math.huge, callback(item))
    end
    return min, max
end

local function getPopups()
    return vim.fn.filter(vim.api.nvim_tabpage_list_wins(0),
        function(_, e) return vim.api.nvim_win_get_config(e).zindex end)
end

local function popupOpen()
    return #getPopups() > 0
end

local defaultJumpDiagnosticOpts = {
    float = {
        format = function(diagnostic)
            return vim.split(diagnostic.message, "\n")[1]
        end,
        prefix = "",
        suffix = "",
        focusable = false,
        header = ""
    }
}

local function jumpToDiagnostic(direction, initialOpts, subsequentOpts)
    initialOpts = initialOpts or {}
    subsequentOpts = subsequentOpts or initialOpts

    if popupOpen() then
        local opts = {}
        for k, v in pairs(defaultJumpDiagnosticOpts) do opts[k] = v end
        for k, v in pairs(subsequentOpts) do opts[k] = v end
        vim.diagnostic[direction == 1 and "goto_next" or "goto_prev"](opts)
    else
        local cursor_position = nil
        local line = vim.fn.line(".")
        local lineDiagnostics = vim.diagnostic.get(0, {
            lnum = line - 1
        })
        if #lineDiagnostics == 0 then
            cursor_position = {
                line + math.max(direction == 1 and 0 or 1),
                -1,
            }
        else
            local minCol, maxCol = minMax(lineDiagnostics,
                function (d) return d.col end)
            local col = vim.fn.col(".")
            if col <= minCol then
                direction = 1
            elseif col - 1 >= maxCol then
                direction = -1
            end
            cursor_position = { line, col - direction - 1 }
        end
        local opts = { cursor_position = cursor_position }
        for k, v in pairs(defaultJumpDiagnosticOpts) do opts[k] = v end
        for k, v in pairs(initialOpts) do opts[k] = v end
        vim.diagnostic[direction == 1 and "goto_next" or "goto_prev"](opts)
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

            local jumpOpts = { severity = { min = vim.diagnostic.severity.ERROR } }
            vim.keymap.set('n', '<leader><up>', function() jumpToDiagnostic(-1, {}, jumpOpts) end, bufopts)
            vim.keymap.set('n', '<leader><down>', function() jumpToDiagnostic(1, {}, jumpOpts) end, bufopts)

            vim.keymap.set('n', 'g<up>', function()
                vim.diagnostic.open_float({ focusable = false })
            end, bufopts)
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
                        diagnostics = { globals = { 'vim' } }
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
