
print('test')
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = true,
})
