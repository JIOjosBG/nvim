return {
	"gorbit99/codewindow.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local codewindow = require("codewindow")
		codewindow.setup({
			auto_enable = true,
			minimap_width = 10,
			use_lsp = true,
			use_treesitter = true,
			use_git = true,
			exclude_filetypes = { "NvimTree", "neo-tree", "lazy", "mason" },
		})
		codewindow.apply_default_keybinds()

		vim.api.nvim_create_autocmd({ "CursorMovedI", "InsertEnter", "InsertLeave" }, {
			callback = function()
				local ok, highlight = pcall(require, "codewindow.highlight")
				if ok and highlight.update_minimap_cursor then
					highlight.update_minimap_cursor()
				end
			end,
		})
	end,
}
