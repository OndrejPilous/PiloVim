-- Prefered visual options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true -- Force spaces over tabs
vim.opt.wrap = false -- Disable line wrap
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.ruler = false -- Disable the default ruler
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.winborder = 'rounded' -- set default border for all floating windows

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Set language
vim.opt.spelllang = { "en" }

-- Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Delay until refresh - for faster diagnostics and completion popup
vim.opt.updatetime = 300
