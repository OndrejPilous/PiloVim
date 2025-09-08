---@brief
---
--- https://github.com/yioneko/vtsls
---
--- `vtsls` can be installed with npm:
--- ```sh
--- npm install -g @vtsls/language-server
--- ```
---
--- To configure a TypeScript project, add a
--- [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html)
--- or [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to
--- the root of your project.
---
--- ### Vue support
---
--- Since v3.0.0, the Vue language server requires `vtsls` to support TypeScript.
---
--- ```
--- -- If you are using mason.nvim, you can get the ts_plugin_path like this
--- -- For Mason v1,
--- -- local mason_registry = require('mason-registry')
--- -- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
--- -- For Mason v2,
--- -- local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
--- -- or even
--- -- local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
--- local vue_language_server_path = '/path/to/@vue/language-server'
--- local vue_plugin = {
---   name = '@vue/typescript-plugin',
---   location = vue_language_server_path,
---   languages = { 'vue' },
---   configNamespace = 'typescript',
--- }
--- vim.lsp.config('vtsls', {
---   settings = {
---     vtsls = {
---       tsserver = {
---         globalPlugins = {
---           vue_plugin,
---         },
---       },
---     },
---   },
---   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
--- })
--- ```
---
--- - `location` MUST be defined. If the plugin is installed in `node_modules`, `location` can have any value.
--- - `languages` must include vue even if it is listed in filetypes.
--- - `filetypes` is extended here to include Vue SFC.
---
--- You must make sure the Vue language server is setup. For example,
---
--- ```
--- vim.lsp.enable('vue_ls')
--- ```
---
--- See `vue_ls` section and https://github.com/vuejs/language-tools/wiki/Neovim for more information.

return function()
	local ok, registry = pcall(require, "mason-registry")
	if not ok then return end

	local vue_ls
	-- wait for Mason to initialize the package
	for _ = 1, 10 do
		if registry.is_installed("vue-language-server") then
			vue_ls = registry.get_package("vue-language-server")
			break
		end
		vim.wait(50) -- wait 50ms, retry
	end

	if not vue_ls then
		vim.notify("vue-language-server not ready, skipping vtsls", vim.log.levels.WARN)
		return
	end

	local vue_plugin_path = vue_ls:get_install_path() .. "/node_modules/@vue/typescript-plugin"

	local opts = {
		cmd = { "vtsls", "--stdio" },
		filetypes = { "vue" },
		settings = {
			vtsls = {
				tsserver = {
					globalPlugins = { {
						name = "@vue/typescript-plugin",
						location = vue_plugin_path,
						languages = { "vue" },
						configNamespace = "typescript",
					} }
				}
			}
		}
	}

	vim.lsp.config("vtsls", opts)
	vim.lsp.enable("vtsls", opts)
end
