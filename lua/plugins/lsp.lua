return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local cmp_lsp = require("cmp_nvim_lsp")

			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
			)

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
						},
					},
				},
			})

			local vue_language_server_path = vim.fn.expand("$MASON/packages")
				.. "/vue-language-server"
				.. "/node_modules/@vue/language-server"
			local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			}

			local ts_ls_config = {
				init_options = {
					plugins = {
						vue_plugin,
					},
				},
				filetypes = tsserver_filetypes,
			}

			local vue_ls_config = {
				on_init = function(client)
					client.handlers["tsserver/request"] = function(_, result, context)
						local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "ts_ls" })
						local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
						local clients = {}

						vim.list_extend(clients, ts_clients)
						vim.list_extend(clients, vtsls_clients)

						if #clients == 0 then
							vim.notify(
								"Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.",
								vim.log.levels.ERROR
							)
							return
						end
						local ts_client = clients[1]

						local param = unpack(result)
						local id, command, payload = unpack(param)
						ts_client:exec_cmd({
							title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
							command = "typescript.tsserverRequest",
							arguments = {
								command,
								payload,
							},
						}, { bufnr = context.bufnr }, function(_, r)
							local response = r and r.body
							-- TODO: handle error or response nil here, e.g. logging
							-- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
							local response_data = { { id, response } }

							---@diagnostic disable-next-line: param-type-mismatch
							client:notify("tsserver/response", response_data)
						end)
					end
				end,
			}

			require("mason").setup({
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"vue_ls",
					"ts_ls",
					"eslint",
				},
				automatic_instalation = true,
			})

			vim.lsp.config("vue_ls", vue_ls_config)
			vim.lsp.config("ts_ls", ts_ls_config)
			vim.lsp.enable({ "ts_ls", "vue_ls" }) -- If using `ts_ls` replace `vtsls` to `ts_ls`

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					vim.opt.completeopt = { "menu", "menuone", "fuzzy", "popup", "noselect" }

					vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

					-- Press <leader>ca for code actions/quick fixes
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
					vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction (Visual)" })

					-- Rename symbol
					vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode [R]ename (Symbol)" })
					-- Go to type definition
					vim.keymap.set(
						"n",
						"<leader>gy",
						vim.lsp.buf.type_definition,
						{ buffer = ev.buf, desc = "Go to Type Definition" }
					)

					-- Go to definition
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]o to [D]efinition" })
				end,
			})

			require("lspconfig").eslint.setup({
				on_attach = function(client, bufnr)
					-- optional: keymap to run eslint fix
					vim.keymap.set("n", "<leader>ef", function()
						vim.lsp.buf.code_action({ context = { only = { "source.fixAll.eslint" } } })
					end, { buffer = bufnr, desc = "Fix all ESLint issues" })
				end,
				settings = {
					frmat = false,
				},
				flags = {
					debounce_text_changes = 150,
				},
			})
			require("lspconfig").stylelint_lsp.setup({
				settings = {
					stylelintplus = {
						autoFixOnSave = false,
						validatOnType = true,
					},
				},
			})

			-- Diagnostics
			vim.diagnostic.config({
				-- Use the default configuration
				-- virtual_lines = true

				-- Alternatively, customize specific options
				virtual_lines = {
					-- Only show virtual line diagnostics for the current cursor line
					current_line = true,
				},
				virtual_text = true,
				signs = true,
				update_in_insert = true,
				underline = true,
				severity_sort = true,
			})
		end,
	},
	{
		-- formatters setup
		"stevearc/conform.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				vue = { "prettier" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)

			-- Keymap for formatting the buffer (e.g., <leader>df)
			vim.keymap.set("n", "<leader>df", function()
				require("conform").format({
					async = true,
					fallback = "lsp",
				})
				-- vim.lsp.buf.format({
				--   async = true, -- Non-blocking for large files
				-- })
			end, { desc = "[D]ocument [F]ormat (format buffer with LSP)" })

			local conform = require("conform")

			-- This will setup autocmd that formats on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					conform.format({ bufnr = args.buf })
				end,
			})
		end,
	},
}
