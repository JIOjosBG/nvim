return {
	"lewis6991/gitsigns.nvim",
	config = function()
		-- Inline blame highlights
		vim.api.nvim_set_hl(0, "GitBlameRecent", { fg = "#98c379", italic = true })
		vim.api.nvim_set_hl(0, "GitBlameNormal", { fg = "#e5c07b", italic = true })
		vim.api.nvim_set_hl(0, "GitBlameAging",  { fg = "#d19a66", italic = true })
		vim.api.nvim_set_hl(0, "GitBlameOld",    { fg = "#5c6370", italic = true })

		-- Heatmap gutter highlights (hot = recent → cooled = old)
		vim.api.nvim_set_hl(0, "GitHeat1", { fg = "#ffffff" }) -- < 1 day:   white hot
		vim.api.nvim_set_hl(0, "GitHeat2", { fg = "#ffd700" }) -- < 3 days:  yellow
		vim.api.nvim_set_hl(0, "GitHeat3", { fg = "#ff8c00" }) -- < 1 week:  orange
		vim.api.nvim_set_hl(0, "GitHeat4", { fg = "#ff4500" }) -- < 1 month: red-orange
		vim.api.nvim_set_hl(0, "GitHeat5", { fg = "#8b0000" }) -- < 3 months: dark red (cooling)
		vim.api.nvim_set_hl(0, "GitHeat6", { fg = "#4a4a8a" }) -- < 1 year:  cold blue
		vim.api.nvim_set_hl(0, "GitHeat7", { fg = "#2a2a2a" }) -- older:     near-black (cold)

		local function blame_hl(age)
			if age < 7 * 86400   then return "GitBlameRecent" end
			if age < 30 * 86400  then return "GitBlameNormal" end
			if age < 180 * 86400 then return "GitBlameAging"  end
			return "GitBlameOld"
		end

		local function heat_hl(age)
			if age < 86400        then return "GitHeat1" end
			if age < 3 * 86400   then return "GitHeat2" end
			if age < 7 * 86400   then return "GitHeat3" end
			if age < 30 * 86400  then return "GitHeat4" end
			if age < 90 * 86400  then return "GitHeat5" end
			if age < 365 * 86400 then return "GitHeat6" end
			return "GitHeat7"
		end

		local heatmap_ns = vim.api.nvim_create_namespace("git_heatmap")
		local heatmap_active = {}

		local function get_line_times(bufnr)
			local file = vim.api.nvim_buf_get_name(bufnr)
			if file == "" then return nil end
			local dir = vim.fn.shellescape(vim.fn.fnamemodify(file, ":h"))
			local out = vim.fn.systemlist("git -C " .. dir .. " blame --porcelain " .. vim.fn.shellescape(file))
			if vim.v.shell_error ~= 0 then return nil end

			local times, commit_times = {}, {}
			local cur_sha, cur_line = nil, nil
			for _, raw in ipairs(out) do
				local sha = raw:match("^(%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x)")
				if sha then
					cur_sha  = sha
					cur_line = tonumber(raw:match("^%x+ %d+ (%d+)"))
				elseif raw:match("^author%-time ") then
					commit_times[cur_sha] = tonumber(raw:match("^author%-time (%d+)"))
				elseif raw:sub(1, 1) == "\t" then
					if cur_line and cur_sha and commit_times[cur_sha] then
						times[cur_line] = commit_times[cur_sha]
					end
				end
			end
			return times
		end

		local function toggle_heatmap(bufnr)
			if heatmap_active[bufnr] then
				vim.api.nvim_buf_clear_namespace(bufnr, heatmap_ns, 0, -1)
				heatmap_active[bufnr] = false
				return
			end
			local times = get_line_times(bufnr)
			if not times then return end
			local now = os.time()
			for line, ts in pairs(times) do
				vim.api.nvim_buf_set_extmark(bufnr, heatmap_ns, line - 1, 0, {
					sign_text     = "│",
					sign_hl_group = heat_hl(now - ts),
					priority      = 5,
				})
			end
			heatmap_active[bufnr] = true
		end

		require("gitsigns").setup({
			signs = {
				add          = { text = "▎+" },
				change       = { text = "▎~" },
				delete       = { text = "▎-" },
				topdelete    = { text = "▎‾" },
				changedelete = { text = "▎±" },
				untracked    = { text = "▎?" },
			},

			current_line_blame = true,
			current_line_blame_opts = {
				virt_text_pos = "eol",
				delay = 300,
			},
			current_line_blame_formatter = function(name, info, _)
				local date = os.date("%Y-%m-%d", info.author_time)
				local summary = info.summary or ""
				return { { ("  %s, %s · %s"):format(name, date, summary), blame_hl(os.time() - info.author_time) } }
			end,
			current_line_blame_formatter_nc = function(_, _)
				return { { "  Not committed yet", "GitBlameOld" } }
			end,

			on_attach = function(bufnr)
				vim.keymap.set("n", "<leader>gb", require("gitsigns").toggle_current_line_blame,
					{ buffer = bufnr, desc = "Toggle git blame" })
				vim.keymap.set("n", "<leader>gh", function() toggle_heatmap(bufnr) end,
					{ buffer = bufnr, desc = "Toggle git heatmap" })
				toggle_heatmap(bufnr)
			end,
		})
	end,
}
