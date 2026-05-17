return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",

	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
				icons_enabled = true,
				globalstatus = true,
			},

			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" },
				lualine_c = {
					{
						"filename",
						path = 1,
					},
					{
						function()
							if vim.b.autoformat == false then
								return "󰉶 no fmt" -- only shows when OFF
							end
							return ""
						end,
						color = { fg = "#e06c75" }, -- red to draw attention
					},
				},
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
				},

				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
