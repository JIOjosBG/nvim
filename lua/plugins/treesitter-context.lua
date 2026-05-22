return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"lua", "vim", "vimdoc",
				"c", "cpp",
				"javascript", "typescript", "tsx",
				"python", "rust", "go",
				"json", "yaml", "toml",
				"html", "css", "scss",
				"bash", "markdown",
			},
			auto_install = true,
			highlight = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			enable = true,
			max_lines = 0,
			multiline_threshold = 1,
		},
	},
}
