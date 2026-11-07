return {
	{
		-- Colorscheme that styles tree-sitter and LSP semantic token groups.
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({ style = "night" })

			-- Extra Rust highlights from rust-analyzer semantic tokens.
			-- Use :Inspect on a token to find its group name.
			local function set_rust_hl()
				local set = vim.api.nvim_set_hl
				set(0, "@lsp.mod.mutable.rust", { underline = true })
				set(0, "@lsp.typemod.variable.mutable.rust", { underline = true })
				set(0, "@lsp.mod.unsafe.rust", { fg = "#ff6c6b", bold = true })
				set(0, "@lsp.typemod.function.unsafe.rust", { fg = "#ff6c6b", bold = true })
				set(0, "@lsp.type.lifetime.rust", { fg = "#e5c07b", italic = true })
				set(0, "@lsp.type.macro.rust", { fg = "#c678dd" })
				set(0, "@lsp.type.derive.rust", { fg = "#c678dd", italic = true })
				set(0, "@lsp.type.selfKeyword.rust", { fg = "#f7768e", italic = true })
				set(0, "@lsp.type.selfTypeKeyword.rust", { fg = "#f7768e", italic = true })
				set(0, "@lsp.type.typeAlias.rust", { fg = "#2ac3de" })
				set(0, "@lsp.type.enumMember.rust", { fg = "#ff9e64" })

				-- Bracket under the cursor: use a background so it never looks
				-- like a rainbow-delimiters color (they only change the text color).
				set(0, "MatchParen", { fg = "#ffffff", bg = "#3d59a1", bold = true })
			end

			set_rust_hl()
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("RustSemanticHl", {}),
				callback = set_rust_hl,
				desc = "Keep Rust semantic token highlights after colorscheme change",
			})

			vim.cmd.colorscheme("tokyonight")
		end,
	},
	{
		-- Colors matching brackets by nesting depth.
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
	},
}
