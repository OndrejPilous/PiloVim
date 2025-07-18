-- Prefered visual options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = false -- Disable line wrap
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.ruler = false -- Disable the default ruler
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = true,
})

-- Set language
vim.opt.spelllang = { "en" }

-- Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
