require "sanity"

return require "lazier" {
    "jake-stewart/jfind.nvim",
    dir = "~/clones/jfind.nvim",
    branch = "2.0",
    config = function()
        local jfind = require("jfind")
        local key = require("jfind.key")

        jfind.setup({
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
                "ci",
                "dist",
                "public",
                "*.iml",
                "*.meta"
            },
            key = "<c-f>",
            tmux = true
        })

        local preview = table({
            "bat",
            "--color", "always",
            "--theme", "ansi",
            "--style", "plain",
        }):_join(" ")

        local function filePicker(query)
            jfind.findFile({
                formatPaths = true,
                preview = preview,
                query = query,
                previewPosition = "right",
                previewPercent = 0.6,
                previewMinWidth = 60,
                queryPosition = "top",
                hidden = true,
                callback = {
                    [key.DEFAULT] = vim.cmd.edit,
                    [key.CTRL_B] = vim.cmd.split,
                    [key.CTRL_N] = vim.cmd.vsplit,
                }
            })
        end

        local function cmdFilePicker()
            jfind.findFile({
                formatPaths = true,
                preview = preview,
                previewPosition = "right",
                previewPercent = 0.6,
                previewMinWidth = 60,
                queryPosition = "top",
                hidden = true,
                callback = {
                    [key.DEFAULT] = vim.fn.feedkeys,
                }
            })
        end

        local function liveGrepPicker()
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
                    [key.DEFAULT] = jfind.editGotoLine,
                    [key.CTRL_B] = jfind.splitGotoLine,
                    [key.CTRL_N] = jfind.vsplitGotoLine,
                }
            })
        end

        local function bufferPicker()
            local input = table(vim.api.nvim_list_bufs())
                :_filter(function(buf)
                    return vim.api.nvim_buf_is_loaded(buf)
                end)
                :_map(function(buf)
                    local name = vim.api.nvim_buf_get_name(buf) or ""
                    local displayName = name == ""
                        and "[No Name]"
                        or jfind.formatPath(name)
                    local hint = buf .. " " .. name
                    return { displayName, hint }
                end)
                :_flat()

            jfind.jfind({
                input = input,
                hints = true,
                formatPaths = true,
                showQuery = true,
                acceptNonMatch = true,
                preview = preview
                    .. " $(echo {} | awk '{$1=\"\"; print $0}')",
                previewPosition = "right",
                previewPercent = 0.6,
                previewMinWidth = 60,
                queryPosition = "top",
                hidden = true,
                callbackWrapper = function(callback, item, query)
                    callback(item:_split(" ")[1], query)
                end,
                callback = {
                    [key.ESCAPE] = function() end,
                    [key.DEFAULT] = function(result)
                        return vim.cmd.buffer(result)
                    end,
                    [key.CTRL_B] = function(result)
                        vim.cmd.split()
                        vim.cmd.buffer(result)
                    end,
                    [key.CTRL_N] = function(result)
                        vim.cmd.vsplit()
                        vim.cmd.buffer(result)
                    end,
                    [key.CTRL_F] = function(_, query)
                        filePicker(query)
                    end
                }
            })
        end

        local function liveGrepQfListPicker()
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
                    [key.DEFAULT] = function(results)
                        results = table(results)
                            :_map(function(result)
                                result = table(result)
                                return {
                                    filename = result[1],
                                    lnum = result[2],
                                }
                            end)
                        vim.fn.setqflist(results)
                        if #results > 0 then
                            vim.cmd.cc()
                        end
                    end
                }
            })
        end

        vim.keymap.set("n", "<c-f>", filePicker)
        vim.keymap.set("c", "<c-f>", cmdFilePicker)
        vim.keymap.set("n", "<c-b>", bufferPicker)
        vim.keymap.set("n", "<leader><c-f>", liveGrepPicker)
        vim.keymap.set("n", "<leader><c-a>", liveGrepQfListPicker)
    end
}
