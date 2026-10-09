vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".git" },
	settings = {
		Lua = { diagnostics = { globals = { "vim" } } },
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

vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	-- Use the nearest Cargo.toml, so a Rust folder inside a JS project gets its own root.
	root_dir = function(bufnr, on_dir)
		local file = vim.api.nvim_buf_get_name(bufnr)
		local root = vim.fs.root(file, { "Cargo.toml", "rust-project.json" })
		if root then
			on_dir(root)
		end
	end,
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			check = { command = "clippy" },
		},
	},
})

vim.lsp.enable("rust_analyzer")
vim.lsp.enable("clangd")
vim.lsp.enable("dartls")
vim.lsp.enable("vtsls")
vim.lsp.enable("eslint")
vim.lsp.enable("cssls")
vim.lsp.enable("lua_ls")
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
