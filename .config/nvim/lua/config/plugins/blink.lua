
return {
    "Saghen/blink.cmp",
    event = "VeryLazy",
    enabled = false,
    build = "cargo build --release",
    opts = {
        signature = {
            enabled = true,
            window = {
                show_documentation = true
            }
        },
        cmdline = {
            enabled = false,
        },

        fuzzy = {
            implementation = "prefer_rust",
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
