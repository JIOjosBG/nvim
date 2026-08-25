local ignore_globs = { ".git", "node_modules", "dist", "build" }

-- Show the previewed file's path alongside the preview, since the dropdown
-- theme's border doesn't render Telescope's built-in preview title. The
-- preview window is a `style = "minimal"` float, which never shows a
-- statusline unless 'laststatus' is 3, so a winbar is the reliable spot.
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  group = vim.api.nvim_create_augroup("TelescopePreviewFilename", { clear = true }),
  callback = function(args)
    local bufname = args.data and args.data.bufname
    if not bufname or bufname == "" then
      return
    end
    local win = vim.fn.bufwinid(args.buf)
    if win == -1 then
      return
    end
    vim.wo[win].winbar = "%=" .. vim.fn.fnamemodify(bufname, ":.") .. "%="
  end,
})

-- Files with uncommitted changes, relative to the current working directory.
local function changed_files()
  -- --untracked-files=all expands new directories into their individual
  -- files, instead of collapsing them into one directory entry.
  local out =
    vim.fn.systemlist({ "git", "-c", "core.quotepath=off", "status", "--porcelain", "--untracked-files=all" })
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local root = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]
  if vim.v.shell_error ~= 0 or not root then
    return {}
  end

  local files = {}
  for _, line in ipairs(out) do
    local path = line:sub(4)
    -- renames/copies are reported as "old -> new"
    path = path:match("%s%->%s(.+)$") or path
    path = path:gsub('^"(.*)"$', "%1")
    table.insert(files, vim.fn.fnamemodify(root .. "/" .. path, ":."))
  end
  return files
end

local function all_files()
  local cmd = { "rg", "--files", "--hidden" }
  for _, glob in ipairs(ignore_globs) do
    table.insert(cmd, "--glob")
    table.insert(cmd, "!" .. glob)
  end
  return vim.fn.systemlist(cmd)
end

-- Wrap an entry_maker so files with uncommitted changes get a "● " prefix.
local function boosting_entry_maker(make, changed)
  return function(line)
    local entry = make(line)
    if entry and changed[entry.filename] then
      local display = entry.display
      entry.display = function(e)
        local text, highlights = display(e)
        local prefix = "● "
        local shift = #prefix
        for _, hl in ipairs(highlights or {}) do
          hl[1][1] = hl[1][1] + shift
          hl[1][2] = hl[1][2] + shift
        end
        return prefix .. text, highlights
      end
    end
    return entry
  end
end

-- Sorter for live_grep: never filters (rg already filtered the results by
-- the prompt), and keeps a fuzzy highlighter, but leaves the actual ordering
-- to `tiebreak` below by giving every entry the same (sub-1) score.
local function grep_sorter()
  local fzy = require("telescope.algos.fzy")
  return require("telescope.sorters").Sorter:new({
    scoring_function = function()
      return 0
    end,
    highlighter = function(_, prompt, display)
      return fzy.positions(prompt, display)
    end,
  })
end

-- Order live_grep results by file name, then line number, with files that
-- have uncommitted changes sorted first.
local function grep_tiebreak(changed)
  return function(a, b)
    local a_changed, b_changed = changed[a.filename] or false, changed[b.filename] or false
    if a_changed ~= b_changed then
      return a_changed
    end
    if a.filename ~= b.filename then
      return a.filename < b.filename
    end
    return (a.lnum or 0) < (b.lnum or 0)
  end
end

-- Wrap the default file sorter so changed files keep winning while typing.
local function boosting_sorter(changed)
  local sorter = require("telescope.config").values.file_sorter({})
  local score = sorter.scoring_function
  sorter.scoring_function = function(self, prompt, line, entry)
    local result = score(self, prompt, line, entry)
    if result < 0 then
      return result
    end
    return changed[line] and result * 0.5 or result
  end
  return sorter
end

local function find_files()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")

  local changed, results, seen = {}, {}, {}
  for _, file in ipairs(changed_files()) do
    local stat = vim.uv.fs_stat(file)
    if stat and stat.type == "file" and not seen[file] then
      seen[file] = true
      changed[file] = true
      table.insert(results, file)
    end
  end
  for _, file in ipairs(all_files()) do
    if not seen[file] then
      seen[file] = true
      table.insert(results, file)
    end
  end

  local entry_maker = boosting_entry_maker(make_entry.gen_from_file({}), changed)

  pickers
    .new({}, {
      prompt_title = "Find Files",
      finder = finders.new_table({
        results = results,
        entry_maker = entry_maker,
      }),
      sorter = boosting_sorter(changed),
      previewer = require("telescope.config").values.file_previewer({}),
    })
    :find()
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },

  opts = {
    defaults = {
      theme = "dropdown",
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--fixed-strings",
      },
    },
  },

  keys = {
    {
      "<C-p>",
      find_files,
      mode = { "n", "i", "v" },
      desc = "Find files (changed first)",
    },

    {
      "<leader>fs",
      function()
        local make_entry = require("telescope.make_entry")
        local conf = require("telescope.config").values

        local changed = {}
        for _, file in ipairs(changed_files()) do
          changed[file] = true
        end

        require("telescope.builtin").live_grep({
          use_regex = false,
          entry_maker = boosting_entry_maker(make_entry.gen_from_vimgrep({
            vimgrep_arguments = conf.vimgrep_arguments,
          }), changed),
          sorter = grep_sorter(),
          tiebreak = grep_tiebreak(changed),
        })
      end,
      desc = "Live exact search",
    },
  },
}
