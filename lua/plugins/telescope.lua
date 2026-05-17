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
      function()
        require("telescope.builtin").find_files({
          hidden = true,
          file_ignore_patterns = {
            "node_modules",
            "dist",
            "build",
          },
        })
      end,
      mode = { "n", "i", "v" },
      desc = "Find files",
    },

    {
      "<leader>fs",
      function()
        require("telescope.builtin").live_grep({
          use_regex = false,
        })
      end,
      desc = "Live exact search",
    },
  },
}
