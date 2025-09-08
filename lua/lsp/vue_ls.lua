local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json", "tsconfig.json", ".git" },
	init_options = {
		vue = { hybridMode = true },
		embeddedLanguages = { html = true, css = true, javascript = true, ts = true },
	},
	capabilities = capabilities,

}
