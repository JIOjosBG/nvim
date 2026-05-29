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

vim.lsp.config("cssls", {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_markers = { "package.json", ".git" },
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
})

vim.lsp.config("dartls", {
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	root_markers = { "pubspec.yaml", ".git" },
	settings = {
		dart = {
			completeFunctionCalls = true,
			showTodos = true,
		},
	},
})

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--query-driver=/usr/bin/g++,/usr/bin/gcc,/usr/bin/clang,/usr/bin/clang++",
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
})

vim.lsp.enable("clangd")
vim.lsp.enable("dartls")
vim.lsp.enable("vtsls")
vim.lsp.enable("eslint")
vim.lsp.enable("cssls")
vim.lsp.enable("lua_ls")
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
