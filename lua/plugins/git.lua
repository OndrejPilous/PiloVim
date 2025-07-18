return ({
    {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>tg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
},
{
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup {
	signs = {
	    add          = { hl = "GitSignsAdd",    text = "\u{f457}" }, 
	    change       = { hl = "GitSignsChange", text = "\u{f0dec}" }, 
	    delete       = { hl = "GitSignsDelete", text = "\u{f458}" }, 
	    topdelete    = { hl = "GitSignsDelete", text = "\u{f458}" },
	    changedelete = { hl = "GitSignsChange", text = "\u{f0de9}" },
	    untracked    = { hl = "GitSignsAdd",    text = "\u{f420}" }, 
	},
        signcolumn = true,
        numhl      = false,
        linehl     = false,
        word_diff  = false,
        watch_gitdir = { follow_files = true },
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          -- ... same on_attach from before
        end,
      }
    end,
  },
})
