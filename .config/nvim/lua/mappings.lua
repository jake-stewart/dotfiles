-- zero width space digraph
vim.cmd.digraph("zs " .. 0x200b)

-- toggle cursor column
vim.keymap.set("n", "<leader>cc", ":let &cuc = !&cuc<cr>", {silent=true})

-- toggle color column
vim.keymap.set("n", "<leader>8", ":let &cc = &cc == 0 ? 80 : 0<cr>", {silent=true})

-- visually select pasted content
vim.keymap.set("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", {expr=true})

-- clear search highlight
vim.keymap.set("n", "<esc>", ":<C-U>noh<cr>", {silent=true})

vim.keymap.set("n",
    "<leader>n",
    ":let @/='\\C\\V\\<'.expand(\"<cword>\").'\\>'<CR>:set hls<CR>cgn",
    {silent=true}
)
vim.keymap.set("n",
    "<leader>N",
    ":let @/='\\C\\V\\<'.expand(\"<cword>\").'\\>'<CR>:set hls<CR>cgN",
    {silent=true}
)

-- cgn on selection
vim.keymap.set("v", "<leader>n", "\"zy:let @/='\\C\\V'.@z<CR>:set hls<CR>cgn", {silent=true})
vim.keymap.set("v", "<leader>N", "\"zy:let @/='\\C\\V'.@z<CR>:set hls<CR>cgN", {silent=true})

-- record macro on current word and selection
vim.keymap.set("n", "<leader>q", ":let @/='\\C\\V\\<'.expand(\"<cword>\").'\\>'<CR>:set hls<CR>qq", {silent=true})
vim.keymap.set("v", "<leader>q", "zy:let @/='\\C\\V'.@z<CR>:set hls<CR>qq", {silent=true})

-- ^, $, and %, <c-^> are motions I use all the time
-- however, the keys are in awful positions
vim.keymap.set({"n", "v"}, "gh", "^")
vim.keymap.set({"n", "v"}, "gl", "$")
vim.keymap.set({"n", "v"}, "gm", "%")
vim.keymap.set("n", "<c-p>", "<c-^>")

vim.keymap.set("n", "H", "H^")
vim.keymap.set("n", "M", "M^")
vim.keymap.set("n", "L", "L^")

-- stop Ignorecase for * and #
-- # in middle of a word should jump to previous word, not start of current
vim.keymap.set("n", "*", ":let @/='\\C\\<' . expand('<cword>') . '\\>'<CR>:let v:searchforward=1<CR>n", {silent=true})
vim.keymap.set("n", "#", "\"_yiw:let @/='\\C\\<' . expand('<cword>') . '\\>'<CR>:let v:searchforward=0<CR>n", {silent=true})
 
-- visual # and * don't yank to default register
vim.keymap.set("v", "*", '"zy/\\V<C-R>z<CR>')
vim.keymap.set("v", "#", '"zy?\\V<C-R>z<CR>')

vim.keymap.set("n", "gn", "\"zyiw:let @/='\\C\\<'.@z.'\\>'<CR>:set hls<CR>", {silent=true})
vim.keymap.set("v", "gn", "\"zy:let @/='\\C'.@z<CR>:set hls<CR>", {silent=true})

-- I center screen all the time, zz is slow and hurts my finger
vim.keymap.set("n", "gb", "zz")

vim.keymap.set("n", "<leader>s", "1z=")

-- dd, yy, cc, etc all take too long since the same key is pressed twice
-- use dl, yl, cl etc instead
vim.keymap.set("o", "l", "_")
vim.keymap.set("o", "c", "l")

-- jump words skipping symbols with ctrl
vim.keymap.set("n", 
    "<c-w>",
    ':call search("[a-zA-Z0-9_]\\\\@=\\\\<", "z")<CR>',
    {silent=true}
)
vim.keymap.set("n", 
    "<c-b>",
    ':call search("[a-zA-Z0-9_]\\\\@=\\\\<", "b")<CR>',
    {silent=true}
)
vim.keymap.set("n",
    "<c-e>",
    ':call search("[a-zA-Z0-9_]\\\\>", "z")<CR>',
    {silent=true}
)

vim.keymap.set("n", "<leader>i", "~hi");
vim.keymap.set("v", "<leader>i", "~gvI");
-- function fullyJumpIn()
--     local path = vim.fn.expand("%:h")
--     while (true) do
--         vim.cmd.norm("<c-i>")
--         if (vim.fn.expand("%:h") ~= path) then
--             break
--         end
--     end
-- end

-- function fullyJumpOut()
-- end

-- vim.keymap.set("n", "<leader>i", fullyJumpIn)
-- vim.keymap.set("n", "<leader>o", fullyJumpOut)

vim.keymap.set("v", "<c-w>", "<esc><c-w>mzgv`z", {silent=true, noremap=false});
vim.keymap.set("v", "<c-b>", "<esc><c-b>mzgv`z", {silent=true, noremap=false});
vim.keymap.set("v", "<c-e>", "<esc><c-e>mzgv`z", {silent=true, noremap=false});

-- remap <c-w> since above mappings remove it
vim.keymap.set("n", "g<c-w>", "<c-w>")

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>[', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>]', vim.diagnostic.goto_next, opts)
