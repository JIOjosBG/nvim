vim.keymap.set("x", "p", [["_dP]])
vim.keymap.set("x", "P", [["_dP]])

vim.keymap.set({ "n", "x" }, "d", '"_d')
vim.keymap.set({ "n", "x" }, "D", '"_D')
vim.keymap.set({ "n", "x" }, "x", '"_x')

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

vim.keymap.set("n", "<leader>t", function()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("No file in this buffer", vim.log.levels.WARN)
		return
	end

	local root = vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
	local path = vim.fs.relpath(root, file) or file

	vim.fn.setreg("+", path)
	vim.notify("Copied " .. path)
end, { desc = "Copy file path relative to project root" })

-- fix nearest spelling error and return to position
-- vim.keymap.set("n", "<leader>sf", "ms[s1z=`s", { desc = "Fix nearest spelling error" })

local float_term_buf = nil
local float_term_win = nil

vim.keymap.set({ "n", "t" }, "<C-\\>", function()
	if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
		vim.api.nvim_win_hide(float_term_win)
		float_term_win = nil
		return
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.7)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	if not (float_term_buf and vim.api.nvim_buf_is_valid(float_term_buf)) then
		float_term_buf = vim.api.nvim_create_buf(false, true)
	end

	float_term_win = vim.api.nvim_open_win(float_term_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	if vim.bo[float_term_buf].buftype ~= "terminal" then
		vim.cmd("terminal")
	end

	vim.cmd("startinsert")
end)
