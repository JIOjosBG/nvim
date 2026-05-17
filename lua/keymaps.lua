vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
	vim.cmd("w")
end)

vim.keymap.set("t", "jk", [[<C-\><C-n>]])

vim.keymap.set("n", "<leader>sp", function()
	vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = "Toggle spell check" })

-- fix nearest spelling error and return to position
-- vim.keymap.set("n", "<leader>sf", "ms[s1z=`s", { desc = "Fix nearest spelling error" })

