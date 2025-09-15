vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- before plugins are loaded
require("config.options")
require("config.autocmds")
require("config.keymaps")

-- plugins are loaded
require("core.lazy")
