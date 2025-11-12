return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = {
      format_on_save = function(bufnr)
        return {
          lsp_fallback = true,
          timeout_ms = 2000,
        }
      end,
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        go = { "goimports" },
        rust = { "rustfmt" },
        solidity = { "prettier_solidity" },
      },
      formatters = {
        prettier_solidity = {
          command = "prettier",
          args = {
            "--plugin=prettier-plugin-solidity",
            "--stdin-filepath",
            "$FILENAME",
          },
          stdin = true,
        },
      },
    },
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
