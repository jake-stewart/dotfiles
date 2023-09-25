return {
    "jake-stewart/jfind.nvim", branch = "2.0",
    keys = {
        {"<c-f>", function()
            local Key = require("jfind.key")
            require("jfind").findFile({
                formatPaths = true,
                preview = true,
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
}
