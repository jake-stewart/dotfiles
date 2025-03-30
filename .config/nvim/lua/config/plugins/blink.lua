return require "lazier" {
    "Saghen/blink.cmp",
    event = "VeryLazy",
    opts = {
        signature = {
            enabled = true,
            window = {
                show_documentation = true
            }
        },
        keymap = {
          preset = 'default',
          ['<Up>'] = { 'select_and_accept', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
        },
        completion = {
            list = {
                selection = {
                    preselect = false
                }
            },
        }
    },
}
