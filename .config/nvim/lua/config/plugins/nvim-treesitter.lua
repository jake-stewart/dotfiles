return require "lazier" {
    "nvim-treesitter/nvim-treesitter",
    ft = {

        "c", "lua", "php", "cpp", "javascript", "typescript",
        "cs", "python", "typescriptreact", "html", "markdown"
    },
    -- event = "VeryLazy",
    config = function()
        require("nvim-treesitter.configs").setup({
            ignore_install = {},
            modules = {},
            ensure_installed = {
                "c",
                "c_sharp",
                "lua",
                "php",
                "cpp",
                "javascript",
                "typescript",
                "html",
                "markdown",
                "markdown_inline"
            },
            sync_install = false,
            auto_install = true,
            indent = {
                enable = true,
                disable = { "python" },
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                disable = { "vimdoc", "vim", "css" },
            }
        })

        require('vim.treesitter.query').set(
            'markdown',
            'highlights',
            [[
(setext_heading
  (paragraph) @markup.heading.1
  (setext_h1_underline) @markup.heading.1)

(setext_heading
  (paragraph) @markup.heading.2
  (setext_h2_underline) @markup.heading.2)

(atx_heading
  (atx_h1_marker)) @markup.heading.1

(atx_heading
  (atx_h2_marker)) @markup.heading.2

(atx_heading
  (atx_h3_marker)) @markup.heading.3

(atx_heading
  (atx_h4_marker)) @markup.heading.4

(atx_heading
  (atx_h5_marker)) @markup.heading.5

(atx_heading
  (atx_h6_marker)) @markup.heading.6

(info_string) @label

(pipe_table_header
  (pipe_table_cell) @markup.heading)

(pipe_table_header
  "|" @punctuation.special)

(pipe_table_row
  "|" @punctuation.special)

(pipe_table_delimiter_row
  "|" @punctuation.special)

(pipe_table_delimiter_cell) @punctuation.special

; Code blocks (conceal backticks and language annotation)
(indented_code_block) @markup.raw.block

((fenced_code_block) @markup.raw.block
  (#set! priority 90))
            
((fenced_code_block_delimiter) @punctuation.delimiter)

(link_destination) @markup.link.url

[
  (link_title)
  (link_label)
] @markup.link.label

((link_label)
  .
  ":" @punctuation.delimiter)

[
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
] @markup.list

(thematic_break) @punctuation.special

(task_list_marker_unchecked) @markup.list.unchecked

(task_list_marker_checked) @markup.list.checked

((block_quote) @markup.quote
  (#set! priority 90))

([
  (plus_metadata)
  (minus_metadata)
] @keyword.directive
  (#set! priority 90))

[
  (block_continuation)
  (block_quote_marker)
] @punctuation.special

(backslash_escape) @string.escape

(inline) @spell
]]
        )
    end
}
