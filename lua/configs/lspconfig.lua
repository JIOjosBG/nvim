local servers = {
  html = {},
  cssls = {},
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        experimentalPostfixCompletions = true,
        goVersion = "", -- allow newer Go versions
        analyses = { unusedparams = true, shadow = true },
        staticcheck = true,
      },
    },
  },
  rust_analyzer = {},
  vtsls = {},
  ["typescript-language-server"] = {},
}

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  update_in_insert = false,
}

vim.fn.sign_define("DiagnosticSignError", { text = "✘" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "▲" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ" })
vim.fn.sign_define("DiagnosticSignHint", { text = "➤" })

vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ",
  trail = "·",
  nbsp = "␣",
}
require("gitsigns").setup {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
}

require("lualine").setup {
  options = { icons_enabled = true },
}
-- read :h vim.lsp.config for changing options of lsp servers
