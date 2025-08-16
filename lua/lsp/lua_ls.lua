return {
    -- command and arguments to start the server
    cmd = {'lua-language-server'},

    filetypes = { 'lua' },

    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },

    -- Specific settings to send to the server. The schema is defined by the server.
    settings = {
	Lua = {
	    runtime = {
		version = 'LuaJIT',
	    },
	},
	diagnostics = {
	    -- Get the language server to recognize the 'vim' global
	    globals = { 'vim' },
	},
	format = {
	    enable = true,
	    defaultConfig = {
		quote_style = "double"
	    }
	}
    }
}
