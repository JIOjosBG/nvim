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
