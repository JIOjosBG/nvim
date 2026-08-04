return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",

	config = function()
		local project = require("project-color")

		local function opts()
			local accent = { bg = project.color(), fg = "#1a1a1a", gui = "bold" }

			return {
				options = {
					theme = "auto",
					icons_enabled = true,
					globalstatus = true,
				},

				sections = {
					lualine_a = { { "mode", color = accent } },
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
					lualine_z = {
						{ project.name, color = accent },
						{ "location", color = accent },
					},
				},
			}
		end

		require("lualine").setup(opts())

		-- Re-derive the accent when the project changes under us.
		vim.api.nvim_create_autocmd("DirChanged", {
			callback = function()
				require("lualine").setup(opts())
			end,
		})
	end,
}
