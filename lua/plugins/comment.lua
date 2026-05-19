return {
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = { enable_autocmd = false },
	},
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})

			local api = require("Comment.api")

			vim.keymap.set("n", "<leader>/", api.toggle.linewise.current, { desc = "Toggle comment" })
			vim.keymap.set("v", "<leader>/", function()
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "nx", false
				)
				api.toggle.linewise(vim.fn.visualmode())
			end, { desc = "Toggle comment" })
		end,
	},
}
