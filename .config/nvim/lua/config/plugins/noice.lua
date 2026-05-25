return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      documentation = {
        opts = {
          scrollbar = true,
        },
      },
      signature = {
        enabled = false, -- using blinkcmp signatures
      },
      hover = {
        enabled = true, -- better than default (adds scrollbar, less obtrusive positioning)
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    cmdline = {
      view = "cmdline_popup", -- keep floating cmdline
      format = {
        lua = false,
        filter = false,
        help = false,
      },
    },
    presets = {
      long_message_to_split = true,
      lsp_doc_border = true,
			inc_rename = true,
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = "95%", -- move down from center (default is 50%)
          col = "50%", -- keep horizontally centered
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = "Normal",
            FloatBorder = "FloatBorder",
          },
        },
      },
    },
  },
  keys = {
    { "<S-Enter>",  function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
    { "<leader>nl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
    { "<leader>nh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
    { "<leader>na", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
    { "<leader>nd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
    { "<leader>nt", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
    { "<c-f>",      function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
    { "<c-b>",      function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
  },
  config = function(_, opts)
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end,
}
