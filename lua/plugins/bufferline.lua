-- Mark buffers with uncommitted changes (as tracked by gitsigns) with a dot.
local function name_formatter(buf)
	local status = vim.b[buf.bufnr].gitsigns_status_dict
	if status and ((status.added or 0) + (status.changed or 0) + (status.removed or 0)) > 0 then
		return buf.name .. " ●"
	end
	return buf.name
end

-- gitsigns fires this whenever a buffer's status changes; redraw the
-- tabline so the "changed" dot stays in sync.
vim.api.nvim_create_autocmd("User", {
	pattern = "GitSignsUpdate",
	callback = function()
		local ok, ui = pcall(require, "bufferline.ui")
		if ok then
			ui.refresh()
		end
	end,
})

return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	keys = {
		{ "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
		{ "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
		{
			"<leader>x",
			function()
				local buf = vim.api.nvim_get_current_buf()
				vim.cmd("BufferLineCycleNext")
				vim.api.nvim_buf_delete(buf, { force = false })
			end,
			desc = "Close buffer",
		},
	},
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			name_formatter = name_formatter,
			custom_filter = function(buf)
				return vim.bo[buf].buftype ~= "terminal"
			end,
			offsets = {
				{
					filetype = "NvimTree",
					text = "Explorer",
					highlight = "Directory",
					separator = true,
				},
			},
		},
	},
}
