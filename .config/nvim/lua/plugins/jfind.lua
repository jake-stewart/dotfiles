local preview = "bat --color always --theme custom --style plain"

return {
    "jake-stewart/jfind.nvim", branch = "2.0",
    keys = {
        {"<c-f>", function()
            local Key = require("jfind.key")
            require("jfind").findFile({
                formatPaths = true,
                preview = preview,
                previewPosition = "right",
                previewPercent = 0.6,
                previewMinWidth = 60,
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
                exclude = {".git"},
                include = {},
                query = "",
                hidden = true,
                preview = preview,
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

        {"<leader><c-a>", function()
            local jfind = require("jfind")
            local Key = require("jfind.key")
            jfind.liveGrep({
                exclude = {".git"},
                include = {},
                query = "",
                hidden = true,
                preview = preview,
                previewPosition = "bottom",
                queryPosition = "top",
                caseSensitivity = "smart",
                selectAll = true,
                callback = {
                    [Key.DEFAULT] = function(results)
                        local qflist = {};
                        for i, v in pairs(results) do
                            qflist[i] = {filename = v[1], lnum = v[2]}
                        end
                        if results[1] then
                            jfind.editGotoLine(results[1][1], results[1][2])
                        end
                        vim.fn.setqflist(qflist)
                    end,
                }
            })
        end},
    },
    config = function()
        require("jfind").setup({
            exclude = {
                ".git*",
                ".idea",
                ".cache",
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
}
