return {
	"echasnovski/mini.map",
	version = false,
	config = function()
		local map = require("mini.map")
		map.setup({
			integrations = {
				map.gen_integration.builtin_search(),
				map.gen_integration.diff(),
				map.gen_integration.diagnostic(),
			},
			symbols = {
				encode = map.gen_encode_symbols.dot("4x2"),
				scroll_line = "▶",
				scroll_view = "┃",
			},
			window = {
				focusable = false,
				side = "right",
				show_integration_count = false,
				width = 10,
				winblend = 25,
			},
		})

		map.open()

		vim.api.nvim_create_autocmd("BufEnter", {
			callback = function()
				local ft = vim.bo.filetype
				local excluded = { NvimTree = true, lazy = true, mason = true, TelescopePrompt = true }
				if excluded[ft] then
					map.close()
				else
					map.open()
				end
			end,
		})

		vim.keymap.set("n", "<Leader>mm", map.toggle, { desc = "Toggle minimap" })
	end,
}
