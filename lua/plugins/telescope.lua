local ignore_globs = { ".git", "node_modules", "dist", "build" }

-- Files with uncommitted changes, relative to the current working directory.
local function changed_files()
  local out = vim.fn.systemlist({ "git", "-c", "core.quotepath=off", "status", "--porcelain" })
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
    if vim.uv.fs_stat(file) and not seen[file] then
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
        })
      end,
      desc = "Live exact search",
    },
  },
}
