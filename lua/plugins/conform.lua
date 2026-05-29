return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "eslint_d", "prettier" },
			javascriptreact = { "eslint_d", "prettier" },
			typescript = { "eslint_d", "prettier" },
			typescriptreact = { "eslint_d", "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			},
		format_on_save = {
			timeout_ms = 2000,
			lsp_format = "fallback",
		},
	},
}
