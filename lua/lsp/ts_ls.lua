local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript", "javascriptreact", "javascript.jsx",
		"typescript", "typescriptreact", "typescript.tsx",
	},
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	init_options = {
		hostInfo = "neovim",
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vim.fn.getcwd() .. "/node_modules/@vue/typescript-plugin",
				languages = { "vue" },
			},
		},
	},
	capabilities = capabilities,

}
