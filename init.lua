vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

package.loaded["lazyvim.config.options"] = true
package.loaded["lazyvim.config.autocmds"] = true
package.loaded["lazyvim.config.keymaps"] = true
require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lsp")

require("core.lazy")

