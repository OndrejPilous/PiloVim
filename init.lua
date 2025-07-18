vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

package.loaded["lazyvim.config.options"] = true
require("config.options")

require("core.lazy")

