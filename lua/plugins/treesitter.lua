return ({{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		run = ":TSUpdate",
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		keys = {
			{ "<c-space>", desc = "Increment Selection" },
			{ "<bs>",      desc = "Decrement Selection", mode = "x" },
		},
		opts_extend = { "ensure_installed" },
		opts = {
			highlight = {
				enable = true, -- false will disable the whole extension
                                additional_vim_regex_highlighting = false
			},
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"css",
				"diff",
                                "go",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"vue",
				"xml",
				"yaml",
			},
			incremental_selection = {
			    enable = true,
			    keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			    }
			},
			autotag = {
			    enable = true
			}
		},
                config = function(_, opts)
                  require("nvim-treesitter.configs").setup(opts)
                end
	},
	{
	    "windwp/nvim-ts-autotag",
	    event = "InsertEnter"
	}

    })
