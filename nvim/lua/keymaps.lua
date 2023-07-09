vim.keymap.set("n", "<leader>pv", ":Ex<CR>")

-- Yank to system clipboard :)
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x%<CR>", {silent = true})
vim.keymap.set("n", "<leader>s", ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')
