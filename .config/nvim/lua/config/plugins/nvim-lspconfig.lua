local plugin = require("config.util.plugin")

local C_STYLE_COMMENT = "//\\ %s"

local SERVER_CONFIGURATIONS = table({
    clangd = {
        filetypes = { "cpp", "c" },
        commentstring = C_STYLE_COMMENT,
    },
    jdtls = {
        filetypes = { "java" },
        commentstring = C_STYLE_COMMENT,
    },
    rust_analyzer = {
        filetypes = { "rust" },
    },
    ts_ls = function()
        local function renameFile()
            local args = {
                sourceUri = vim.api.nvim_buf_get_name(0),
            }
            local inputOpts = {
                prompt = "Target: ",
                completion = "file",
                default = args.sourceUri,
            }
            vim.ui.input(inputOpts, function(input)
                if not input then
                    return
                end
                args.targetUri = input
                vim.lsp.util.rename(args.sourceUri, args.targetUri)
                vim.lsp.buf.execute_command({
                    command = "_typescript.applyRenameFile",
                    arguments = {args},
                    title = "",
                })
            end)
        end
        local inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = false
        }
        return {
            filetypes = { "typescript" },
            settings = {
                typescript = {
                    inlayHints = inlayHints
                }
            },
            commands = {
                RenameFile = {
                    renameFile,
                }
            }
        }
    end,
    intelephense = {
        filetypes = { "php" },
        commentstring = C_STYLE_COMMENT,
    },
    csharp_ls = {
        filetypes = { "cs" },
        commentstring = C_STYLE_COMMENT,
    },
    lua_ls = {
        filetypes = { "lua" },
        settings = {
            Lua = {
                diagnostics = {
                    globals = {
                        "vim",
                    },
                },
            },
        }
    },
    pyright = {
        filetypes = { "python" }
    },
    gopls = {
        filetypes = { "go" }
    },
    angularls = function()
        local HOME = os.getenv("HOME")
        local FNM_ROOT = HOME .. "/Library/Application Support/fnm"
        local ROOT = FNM_ROOT .. "/node-versions/v20.11.1/installation/lib"
        local cmd = {
            "ngserver",
            "--stdio",
            "--tsProbeLocations",
            ROOT,
            "--ngProbeLocations",
            ROOT .. "/node_modules/@angular/language-server",
        }
        return {
            filetypes = { "typescript", "html" },
            cmd = cmd,
            on_new_config = function(new_config)
                new_config.cmd = cmd
            end
        }
    end
})
    :_entries()
    :_map(function(entry)
        local k, config = entry:unpack()
        if type(config) == "function" then
            return table({ k, config() })
        end
        return entry
    end)

local MAPPINGS = {
    ["gD"] = vim.lsp.buf.declaration,
    ["gd"] = vim.lsp.buf.definition,
    ["gy"] = vim.lsp.buf.type_definition,
    ["K"] = vim.lsp.buf.hover,
    ["<leader>r"] = vim.lsp.buf.rename,
    ["<c-r>"] = vim.cmd.LspRestart,
    ["<leader>ca"] = vim.lsp.buf.code_action,
    ["g<up>"] = function()
        vim.diagnostic.open_float({focusable = false})
    end,
    ["gr"] = function()
        local line = vim.fn.line(".")
        vim.lsp.buf.references(nil, {
            on_list = function(qflist)
                table(qflist.items)
                    :_filter(function(item)
                        return item.lnum ~= line
                    end)
                    :_pipe(vim.fn.setqflist)
                vim.cmd.copen()
            end
        })
    end,
}


return plugin("neovim/nvim-lspconfig")
    -- :disable()
    :module("lspconfig", "cmp_nvim_lsp")
    :deps("hrsh7th/nvim-cmp")
    :ft(SERVER_CONFIGURATIONS
        :_map(function(entry)
            return entry:_get(1).filetypes
        end)
        :_flat()
    )
    :setup(function(lspconfig, cmp_nvim_lsp)
        local capabilities = cmp_nvim_lsp.default_capabilities()
        capabilities.textDocument.completion
            .completionItem.snippetSupport = true

        local function onAttach(client, bufnr, opts)
            client.server_capabilities.semanticTokensProvider = nil
            vim.iter(MAPPINGS):each(function(from, to)
                vim.keymap.set("n", from, to, {
                    remap = false,
                    silent = true,
                    buffer = bufnr,
                })
            end)
            if opts and opts.commentstring then
                vim.cmd.setlocal("commentstring=" .. opts.comment)
            end
        end

        local defaultOpts = {
            capabilities = capabilities,
            inlay_hints = {enabled = true},
            on_attach = onAttach,
            init_options = {preferences = {disableSuggestions = true}},
        }

        SERVER_CONFIGURATIONS:_each(function(entry)
	    local server, opts = entry:unpack()
            lspconfig[server].setup(table._spread(opts, defaultOpts))
        end)
    end)
