local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nordtheme/vim"
    },
    {
        "rakr/vim-one"
    },

    {
        'junegunn/fzf'
    },

    {
        'junegunn/fzf.vim'
    },

    {
        "jake-stewart/normon.nvim",
        keys = {
            {"<leader>n", mode = {"n", "v"}},
            {"<leader>N", mode = {"n", "v"}},
            {"<leader>q", mode = {"n", "v"}},
            {"<leader>Q", mdoe = {"n", "v"}},
            {"*", mode = {"n", "v"}},
            {"#", mode = {"n", "v"}}
        },
        config = function()
            local normon = require("normon")
            normon("<leader>n", "cgn")
            normon("<leader>N", "cgN")
            normon("<leader>q", "qq")
            normon("<leader>Q", "qq", {backward = true})
            normon("*", "n", {clearSearch = true})
            normon("#", "n", {backward = true, clearSearch = true})
        end
    },

    {
        "jake-stewart/slide.vim",
        keys = {
            {"<leader>j", mode={"n", "v"}},
            {"<leader>k", mode={"n", "v"}},
            {"<leader>J", mode={"n", "v"}},
            {"<leader>K", mode={"n", "v"}},
        },
    },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        config = function()
            require('telescope').setup {
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    }
                }
            }
            require('telescope').load_extension('fzf')
        end
    },

    {
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
    },

    {
        "jake-stewart/jfind.nvim", branch = "2.0",
        keys = {
            {"<c-f>", function()
                local Key = require("jfind.key")
                require("jfind").findFile({
                    formatPaths = true,
                    preview = true,
                    previewPosition = "right",
                    queryPosition = "top",
                    hidden = true,
                    callback = {
                        [Key.DEFAULT] = vim.cmd.edit,
                        [Key.CTRL_B] = vim.cmd.split,
                        [Key.CTRL_N] = vim.cmd.vsplit,
                    }
                })
            end},

            {"<leader><c-f>", function()
                local jfind = require("jfind")
                local Key = require("jfind.key")
                jfind.liveGrep({
                    exclude = {},
                    include = {},
                    query = "",
                    hidden = true,
                    preview = true,
                    previewPosition = "bottom",
                    queryPosition = "top",
                    caseSensitivity = "smart",
                    callback = {
                        [Key.DEFAULT] = jfind.editGotoLine,
                        [Key.CTRL_B] = jfind.splitGotoLine,
                        [Key.CTRL_N] = jfind.vsplitGotoLine,
                    }
                })
            end},
        },
        config = function()
            require("jfind").setup({
                exclude = {
                    ".git*",
                    ".idea",
                    ".vscode",
                    ".settings",
                    ".classpath",
                    ".gradle",
                    ".project",
                    ".sass-cache",
                    ".class",
                    "__pycache__",
                    "node_modules",
                    "target",
                    "build",
                    "tmp",
                    "assets",
                    "ci",
                    "dist",
                    "public",
                    "*.iml",
                    "*.meta"
                },
                key = "<c-f>",
                tmux = true,
            });
        end
    },

    {
        'tpope/vim-repeat',
        keys = {
            { "." },
        },
    },

    {
        'tpope/vim-surround',
        keys = {
            { "ys" },
            { "ds" },
            { "cs" },
        },
    },

    {
        'christoomey/vim-tmux-navigator',
        keys = {
            { "<m-h>", ":<C-U>TmuxNavigateLeft<cr>",       mode = "n", silent = true },
            { "<m-j>", ":<C-U>TmuxNavigateDown<cr>",       mode = "n", silent = true },
            { "<m-k>", ":<C-U>TmuxNavigateUp<cr>",         mode = "n", silent = true },
            { "<m-l>", ":<C-U>TmuxNavigateRight<cr>",      mode = "n", silent = true },
            { "<m-h>", ":<C-U>TmuxNavigateLeft<cr>gv",     mode = "v", silent = true },
            { "<m-j>", ":<C-U>TmuxNavigateDown<cr>gv",     mode = "v", silent = true },
            { "<m-k>", ":<C-U>TmuxNavigateUp<cr>gv",       mode = "v", silent = true },
            { "<m-l>", ":<C-U>TmuxNavigateRight<cr>gv",    mode = "v", silent = true },
            { "<m-h>", "<c-o>:<C-U>TmuxNavigateLeft<cr>",  mode = "i", silent = true },
            { "<m-j>", "<c-o>:<C-U>TmuxNavigateDown<cr>",  mode = "i", silent = true },
            { "<m-k>", "<c-o>:<C-U>TmuxNavigateUp<cr>",    mode = "i", silent = true },
            { "<m-l>", "<c-o>:<C-U>TmuxNavigateRight<cr>", mode = "i", silent = true },
        },
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
        end
    },

    {
        'tpope/vim-commentary',
        keys = {
            { "gc", mode = "n" },
            { "gc", mode = "v" },
        },
    },

    {
        'tpope/vim-vinegar',
        keys = {
            { "-" },
        },
    },

    {
        'tpope/vim-abolish',
        keys = {
            { "cr" },
        },
        cmd = { "S", "Subvert" },
    },

    {
        'chaoren/vim-wordmotion',
        init = function()
            vim.g.wordmotion_mappings = {
                w = "<c-w>",
                b = "<c-b>",
                e = "<c-e>",
            }
        end,
        keys = {
            { "<c-w>", mode = {"n", "x", "o"} },
            { "<c-b>", mode = {"n", "x", "o"} },
            { "<c-e>", mode = {"n", "x", "o"} },
            { "<space>", "<c-w>", mode = "o", remap=true },
        },
    },

    {
        'machakann/vim-swap',
        keys = {
            { "gs", "<plug>(swap-interactive)" }
        },
    },

    {
        'kevinhwang91/nvim-bqf',
        ft = "qf",
        config = function()
            augroup("BqfCustomKeybinds", { clear = true })

            -- remove auto commenting
            autocmd("FileType", {
                pattern = "qf",
                group = "BqfCustomKeybinds",
                callback = function()
                    vim.keymap.set('n', '<esc>', ":q<CR>",
                        { silent = true, buffer = true })
                end
            })

            require('bqf').setup({
                preview = {
                    winblend = 0,
                    show_title = true,
                    win_height = 999,
                    border_chars = {
                        '│', '│', '─', '─', '┌', '┐', '└', '┘', '█'
                    },
                },
                func_map = {
                    open = "o",
                    openc = "<CR>",
                },
            })
        end
    },

    {
        'kana/vim-textobj-entire',
        dependencies = { 'kana/vim-textobj-user' },
        keys = {
            { "ae", mode = "o" },
            { "ie", mode = "o" },
        },
    },

    {
        'kana/vim-textobj-line',
        dependencies = { 'kana/vim-textobj-user' },
        keys = {
            { "al", mode = "o" },
            { "il", mode = "o" },
        },
    },

    {
        'glts/vim-textobj-comment',
        dependencies = { 'kana/vim-textobj-user' },
        keys = {
            { "ic", mode = "o" },
            { "ac", mode = "o" },
        }
    },

    {
        'michaeljsmith/vim-indent-object',
        dependencies = { 'kana/vim-textobj-user' },
        keys = {
            { "ii", mode = "o" },
            { "ai", mode = "o" },
        },
    },

    {
        'junegunn/vim-easy-align',
        keys = {
            { "<leader>a", "<plug>(EasyAlign)", mode = "v" },
            { "<leader>a", "<plug>(EasyAlign)", mode = "n" },
        },
    },

    {
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
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
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
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp-signature-help',
        },
        event = "InsertEnter",
        config = function()
            local cmp = require('cmp')

            local item_icons = {
                Text = " ",
                Method = "m",
                Function = "f",
                Constructor = "c",
                Field = "f",
                Variable = "v",
                Class = "C",
                Interface = "I",
                Module = "M",
                Property = "p",
                Unit = "u",
                Value = " ",
                Enum = "E",
                Keyword = "k",
                Snippet = " ",
                Color = "c",
                File = "F",
                Reference = "r",
                Folder = "D",
                EnumMember = "E",
                Constant = "c",
                Struct = "S",
                Event = "e",
                Operator = "o",
                TypeParameter = "t"
            }

            local item_sources = {
                buffer   = "[BUF]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[LUA]",
            }

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-K>'] = cmp.mapping.confirm({ select = false }),
                }),
               Window = {
                    completion = cmp.config.window.bordered({
                      winhighlight = "Normal:CmpPmenu,CursorLine:CursorLine,Search:None",
                    }),
                    documentation = cmp.config.window.bordered({
                      winhighlight = "Normal:CmpPmenu,CursorLine:CursorLine,Search:None",
                    }),
                },
                sources = cmp.config.sources(
                    {
                        { name = 'nvim_lsp' },
                        { name = 'vsnip' }
                    },
                    { { name = 'buffer' } },
                    { { name = 'nvim_lsp_signature_help' } }
                ),
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.kind = item_icons[vim_item.kind]
                        vim_item.menu = item_sources[entry.source.name]
                        vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
                        return vim_item
                    end
                },
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                }
            })
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        enabled = false,
        ft = { "c", "lua", "php", "cpp", "javascript", "typescript", "cs" },
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "c",
                    "c_sharp",
                    "lua",
                    "php",
                    "cpp",
                    "javascript",
                    "typescript",
                },
                sync_install = false,
                auto_install = true,
                indent = {
                    enable = false,
                    disable = {
                        "python"
                    },
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                    disable = {
                        "vim", "css"
                    },
                },
            })
        end,
    },

    {
        'Hoffs/omnisharp-extended-lsp.nvim',
        dependencies = { 'neovim/nvim-lspconfig', 'hrsh7th/nvim-cmp' },
        ft = "cs",
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = false
            local on_attach = function(client, bufnr)
                local bufopts = { remap = false, silent = true, buffer = bufnr }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
                vim.keymap.set('n', '<c-k>', function()
                    vim.diagnostic.open_float(nil, { focusable = false })
                end, bufopts)
                -- vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, bufopts);
            end

            local lsp_setup = {
                capabilities = capabilities,
                on_attach = on_attach,
            }

            require('lspconfig').omnisharp.setup({
                cmd = {
                    "dotnet",
                    vim.fn.expand('$HOME/Utilities/omnisharp-osx-arm64-net6.0/OmniSharp.dll')
                },
                handlers = {
                    ["textDocument/definition"] = require('omnisharp_extended').handler,
                },
                enable_editorconfig_support = true,
                enable_ms_build_load_projects_on_demand = false,
                enable_roslyn_analyzers = false,
                organize_imports_on_format = false,
                enable_import_completion = false,
                sdk_include_prereleases = true,
                analyze_open_documents_only = false,
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    if client.name == "omnisharp" then
                        client.server_capabilities.semanticTokensProvider = {
                            full = vim.empty_dict(),
                            legend = {
                                tokenModifiers = { "static_symbol" },
                                tokenTypes = {
                                    "comment",
                                    "excluded_code",
                                    "identifier",
                                    "keyword",
                                    "keyword_control",
                                    "number",
                                    "operator",
                                    "operator_overloaded",
                                    "preprocessor_keyword",
                                    "string",
                                    "whitespace",
                                    "text",
                                    "static_symbol",
                                    "preprocessor_text",
                                    "punctuation",
                                    "string_verbatim",
                                    "string_escape_character",
                                    "class_name",
                                    "delegate_name",
                                    "enum_name",
                                    "interface_name",
                                    "module_name",
                                    "struct_name",
                                    "type_parameter_name",
                                    "field_name",
                                    "enum_member_name",
                                    "constant_name",
                                    "local_name",
                                    "parameter_name",
                                    "method_name",
                                    "extension_method_name",
                                    "property_name",
                                    "event_name",
                                    "namespace_name",
                                    "label_name",
                                    "xml_doc_comment_attribute_name",
                                    "xml_doc_comment_attribute_quotes",
                                    "xml_doc_comment_attribute_value",
                                    "xml_doc_comment_cdata_section",
                                    "xml_doc_comment_comment",
                                    "xml_doc_comment_delimiter",
                                    "xml_doc_comment_entity_reference",
                                    "xml_doc_comment_name",
                                    "xml_doc_comment_processing_instruction",
                                    "xml_doc_comment_text",
                                    "xml_literal_attribute_name",
                                    "xml_literal_attribute_quotes",
                                    "xml_literal_attribute_value",
                                    "xml_literal_cdata_section",
                                    "xml_literal_comment",
                                    "xml_literal_delimiter",
                                    "xml_literal_embedded_expression",
                                    "xml_literal_entity_reference",
                                    "xml_literal_name",
                                    "xml_literal_processing_instruction",
                                    "xml_literal_text",
                                    "regex_comment",
                                    "regex_character_class",
                                    "regex_anchor",
                                    "regex_quantifier",
                                    "regex_grouping",
                                    "regex_alternation",
                                    "regex_text",
                                    "regex_self_escaped_character",
                                    "regex_other_escape",
                                },
                            },
                            range = true,
                        }
                        on_attach(client, bufnr)
                    end
                end,
            })
        end,
    },

    {
        'nvim-treesitter/playground',
        enabled = false,
    },
},
{
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
                -- "matchit",
                -- "matchparen",
            },
        },
    }
});
