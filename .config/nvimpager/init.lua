_G["nvimpager"].maps = false
local nvim_config = vim.fn.expand("$HOME") .. "/.config/nvim"
vim.opt.rtp:append(nvim_config)
vim.cmd.luafile(nvim_config .. "/init.lua")

vim.o.cmdheight = 0
vim.o.number = false
vim.o.cursorline = false

-- function scroll(direction)
--     local rel = vim.fn.winline()
--     if direction == 1 then
--         local ctrl_d = vim.api.nvim_replace_termcodes("<c-d>", true, true, true)
--         vim.api.nvim_feedkeys(ctrl_d, "nx", true)
--     else
--         local ctrl_u = vim.api.nvim_replace_termcodes("<c-u>", true, true, true)
--         vim.api.nvim_feedkeys(ctrl_u, "nx", true)
--     end
--     local target = vim.fn.line('w0') + rel - 1
--     local lastline = vim.fn.line('$')
--     if target > lastline then target = lastline end
--     vim.api.nvim_win_set_cursor(0, {target, vim.fn.col('.') - 1})
-- end

vim.keymap.del("n", "ds")
vim.keymap.set("n", "q", ":q<cr>")
vim.keymap.set("n", "d", "<c-d>", { remap = true })
vim.keymap.set("n", "u", "<c-u>", { remap = true })
