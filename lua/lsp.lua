vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".git" },
	settings = {
		Lua = { diagnostics = { globals = { "vim" } } }
	},
})


vim.lsp.config("vtsls", {
	cmd = { "vtsls", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "package.json", "tsconfig.json", ".git" },

	settings = {
		typescript = { format = { enable = false } },
		javascript = { format = { enable = false } },
	},

	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
})

vim.lsp.config("eslint", {
	settings = {
		format = true,
		workingDirectories = { mode = "auto" },
	},

	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentRangeFormattingProvider = true
	end,
})

-- Enable both
vim.lsp.enable("vtsls")
vim.lsp.enable("eslint")

vim.lsp.enable("lua_ls")
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
