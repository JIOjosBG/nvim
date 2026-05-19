return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		delay = 400,
		icons = { mappings = true },
		spec = {
			{ "<leader>g", group = "git" },
		},
	},
}
