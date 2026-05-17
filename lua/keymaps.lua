vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
	vim.cmd("w")
end)

vim.keymap.set("t", "jk", [[<C-\><C-n>]])
