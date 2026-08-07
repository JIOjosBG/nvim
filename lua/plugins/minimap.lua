return {
	"echasnovski/mini.map",
	version = false,
	config = function()
		local map = require("mini.map")

		-- Distinct, harsher red for errors so they don't blend with GitSignsDelete
		local function set_error_hl()
			vim.api.nvim_set_hl(0, "MiniMapDiagnosticError", { fg = "#FF1F1F", bold = true })
		end
		set_error_hl()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("MiniMapCustomHl", {}),
			callback = set_error_hl,
			desc = "Keep minimap error color after colorscheme change",
		})

		map.setup({
			integrations = {
				map.gen_integration.builtin_search(),
				map.gen_integration.gitsigns(),
				map.gen_integration.diagnostic({ error = "MiniMapDiagnosticError" }),
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
