local plugin = require("config.util.plugin")

local preview = table({
    "bat",
    "--color", "always",
    "--theme", "custom",
    "--style", "plain",
}):_join(" ")

local function filePicker(jfind, key, query)
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

local function cmdFilePicker(jfind, key)
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

local function liveGrepPicker(jfind, key)
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

local function bufferPicker(jfind, key)
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
            item:_split(" "):_get(0):_pipe(callback, query)
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
                filePicker(jfind, key, query)
            end
        }
    })
end
local function liveGrepQfListPicker()
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
                table(results)
                    :_map(function(result)
                        result = table(result)
                        return {
                            filename = result:_get(0),
                            lnum = result:_get(1)
                        }
                    end)
                    :_pipe(vim.fn.setqflist)
                if #results > 0 then
                    vim.cmd.cc()
                end
            end
        }
    })
end

return plugin("jake-stewart/jfind.nvim")
    -- :disable()
    :module("jfind", "jfind.key")
    :dir("~/clones/jfind.nvim")
    :branch("2.0")
    :map("n", "<c-f>", filePicker)
    :map("c", "<c-f>", cmdFilePicker)
    :map("n", "<c-b>", bufferPicker)
    :map("n", "<leader><c-f>", liveGrepPicker)
    :map("n", "<leader><c-a>", liveGrepQfListPicker)
    :setup(function(jfind)
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
    end)
