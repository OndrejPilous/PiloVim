-- lua/lsp/vue_ts_ls.lua
-- Robust Volar (vue-language-server) setup for Neovim 0.11+ + Mason.
-- Tries multiple mason package names and filesystem fallbacks to avoid timing/name issues.

local lspconfig = require("lspconfig")
local caps = (pcall(require, "cmp_nvim_lsp") and require("cmp_nvim_lsp").default_capabilities()) or
	vim.lsp.protocol.make_client_capabilities()

local uv = vim.loop
local stdpath = vim.fn.stdpath
local notify = vim.notify

local candidate_pkg_names = {
	"vue-language-server", -- common mason package name (volar packaged)
	"volar",            -- sometimes used/older
	"vls",              -- vls / vetur-vls variants
}

local function file_exists(path)
	local stat = uv.fs_stat(path)
	return stat and stat.type ~= nil
end

-- Try to get the install path from mason-registry; if not available, use stdpath fallback.
local function find_mason_install_path()
	local mr_ok, mr = pcall(require, "mason-registry")
	if mr_ok and mr then
		-- prefer explicit package from registry
		for _, name in ipairs(candidate_pkg_names) do
			local ok, pkg = pcall(mr.get_package, name)
			if ok and pkg then
				local ok2, install_path = pcall(function() return pkg:get_install_path() end)
				if ok2 and install_path and install_path ~= "" then
					return install_path
				end
			end
		end
	end

	-- Fallback: check stdpath data mason packages dir for candidate names
	local data = stdpath("data")
	for _, name in ipairs(candidate_pkg_names) do
		local p = data .. "/mason/packages/" .. name
		if file_exists(p) then
			return p
		end
	end

	-- Last resort: look for pattern with "vue" in packages dir (best-effort)
	local data_packages = stdpath("data") .. "/mason/packages"
	local handle = uv.fs_scandir(data_packages)
	if handle then
		while true do
			local name = uv.fs_scandir_next(handle)
			if not name then break end
			if name:match("vue") or name:match("volar") or name:match("vls") then
				local p = data_packages .. "/" .. name
				return p
			end
		end
	end

	return nil
end

local function build_plugin_locations(install_path)
	-- Volar's @vue/typescript plugin can be nested. Probe several spots.
	local candidates = {
		-- typical (mason package root may be the npm package root)
		install_path .. "/node_modules/@vue/typescript-plugin",
		-- some distributions put it inside @vue/language-server
		install_path .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
		-- older layout / volar scoped packages
		install_path .. "/node_modules/@volar/vue-language-server/node_modules/@vue/typescript-plugin",
		-- deep nested recursion fallback: try search in node_modules (best-effort)
	}

	-- return locations that exist (first one will be used)
	local found = {}
	for _, p in ipairs(candidates) do
		if file_exists(p) then
			table.insert(found, p)
		end
	end
	return found
end

local function find_server_bin(install_path)
	-- Common executable names and locations
	local bins = {
		install_path .. "/bin/vue-language-server",
		install_path .. "/node_modules/.bin/vue-language-server",
		install_path .. "/node_modules/@vue/language-server/bin/vue-language-server",
		install_path .. "/node_modules/@volar/vue-language-server/bin/vue-language-server",
	}
	for _, b in ipairs(bins) do
		if file_exists(b) then return b end
	end
	return nil
end

local function safe_setup_volar()
	notify("Running safe_setup_volar()", vim.log.levels.INFO)

	local install_path = find_mason_install_path()
	if not install_path then
		notify("mason: could not locate vue-language-server install path (no candidate)", vim.log.levels.WARN)
		return
	end

	local server_bin = find_server_bin(install_path)
	if not server_bin then
		notify("mason: vue-language-server binary not found under " .. install_path, vim.log.levels.WARN)
		return
	end

	-- try to locate typescript plugin(s)
	local plugin_paths = build_plugin_locations(install_path)
	local plugins = {}
	if #plugin_paths > 0 then
		-- use the first hit (should be the real @vue/typescript-plugin)
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = plugin_paths[1],
				languages = { "vue" },
				-- configNamespace = "typescript", -- optional if needed
			},
		}
	end

	-- Setup volar
	local ok, _ = pcall(function()
		lspconfig.volar.setup({
			cmd = { server_bin, "--stdio" },
			filetypes = { "vue", "typescript", "typescriptreact", "javascript", "javascriptreact" },
			init_options = {
				typescript = { tsdk = "" },
				languageFeatures = {
					completion = true,
					diagnostics = true,
					documentFormatting = true,
				},
				plugins = plugins,
			},
			capabilities = caps,
			root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
		})
	end)
	if not ok then
		notify("Failed to setup lspconfig.volar (pcall false)", vim.log.levels.WARN)
		return
	end

	-- If manager exists attach to existing Vue/TS buffers
	if lspconfig.volar and lspconfig.volar.manager then
		notify("Volar manager exists, trying to attach to existing buffers", vim.log.levels.INFO)
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			local ft = vim.bo[bufnr].filetype
			if ft == "vue" or ft == "typescript" or ft == "typescriptreact" then
				pcall(function() lspconfig.volar.manager.try_add_wrapper(bufnr) end)
			end
		end
	end

	-- Auto-attach for future vue files
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
		pattern = "*.vue",
		callback = function(args)
			if lspconfig.volar and lspconfig.volar.manager then
				pcall(function() lspconfig.volar.manager.try_add_wrapper(args.buf) end)
			end
		end,
	})
end

-- If mason-registry is available, refresh then run setup. Otherwise schedule a deferred setup.
local mr_ok, mr = pcall(require, "mason-registry")
if mr_ok and mr and mr.refresh then
	-- refresh will call our callback when registry is ready — but still defensive
	mr.refresh(function()
		-- schedule to avoid tight race with plugin loading
		vim.schedule(function()
			pcall(safe_setup_volar)
		end)
	end)
else
	-- no registry available (or older mason) — run safe_setup_volar after short delay to allow mason to install
	vim.defer_fn(function()
		pcall(safe_setup_volar)
	end, 50)
end
