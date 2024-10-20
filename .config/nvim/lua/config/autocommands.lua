local camelSplit = require("config.util.camel-split")
local augroup = require("config.util.augroup")

local group = augroup("CustomAutocommands")

group:au({
    event = "BufEnter",
    callback = function()
        local fo = vim.bo.formatoptions
        fo = _G.string.gsub(fo, "c", "")
        fo = _G.string.gsub(fo, "r", "")
        fo = _G.string.gsub(fo, "o", "")
        vim.bo.formatoptions = fo
    end
})

group:au({
    event = "FileType",
    pattern = "c,cpp,cs,java,php",
    callback = function()
        vim.cmd.setlocal("commentstring=//\\ %s")
    end
})

group:au({
    event = "FileType",
    pattern = "json",
    callback = function()
        vim.cmd.hi("jsonQuote", "ctermfg=243")
    end
})

group:au({
    event = "BufNewFile",
    pattern = "*.tbl",
    callback = function()
        vim.cmd.setf("tablescript")
    end
})

group:au({
    event = "BufRead",
    pattern = "*.md",
    callback = function()
        local set = vim.keymap.set
        local opts = { buffer = true }
        set("n", "<leader>t-", "yyp0v$r-k", opts)
        set("n", "<leader>t=", "yyp0v$r=k", opts)
    end
})

local function createReactComponent()
    local name = vim.fn.input({prompt = "Component Name: "})
    if not name then
        return
    end
    local formattedName = camelSplit(name)
        :map(function(s)
            return s:_get(0):_upper() .. s:_slice(1):_lower()
        end)
        :join()

    local lineNum = vim.fn.line(".")
    local indent = vim.fn.cindent(lineNum)
    local exportString = indent == 0 and "export " or ""
    vim.api.nvim_buf_set_lines(0, lineNum, lineNum, true, {
        exportString .. "interface " .. formattedName .. "Props {",
        "}",
        "",
        exportString .. "function " .. formattedName
            .. "(props: " .. formattedName .. "Props) {",
        "    return (",
        "        null",
        "    )",
        "}"
    })
    vim.fn.feedkeys("jV7jgq")
end

group:au({
    event = "BufRead",
    pattern = "*.tsx",
    callback = function()
        vim.keymap.set(
            "n",
            "<leader>tp",
            createReactComponent,
            {buffer = true}
        )
    end
})
