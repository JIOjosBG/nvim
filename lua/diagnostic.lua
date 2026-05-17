vim.diagnostic.config({
  virtual_text = {
    prefix = "■",
    spacing = 4,
    source = "if_many",
  },
  virtual_lines = { current_line = true },
  float = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN]  = "▲",
      [vim.diagnostic.severity.HINT]  = "⚑",
      [vim.diagnostic.severity.INFO]  = "»",
    },
  },
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})
