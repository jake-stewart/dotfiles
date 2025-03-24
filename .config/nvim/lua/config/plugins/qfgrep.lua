return require "lazier" {
    "jake-stewart/QFGrep",
    enabled = false,
    lazy = false,
    init = function()
        vim.g.QFG_hi_prompt = "ctermbg=NONE ctermfg=blue"
        vim.g.QFG_hi_info = "ctermbg=NONE ctermfg=NONE"
        vim.g.QFG_hi_error = "ctermbg=NONE ctermfg=red"
    end
}
