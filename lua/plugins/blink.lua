return {
	"saghen/blink.cmp",
	version = "1.*",
	opts = {
		keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		completion = {
			documentation = { auto_show = true },
		},
	},
}
