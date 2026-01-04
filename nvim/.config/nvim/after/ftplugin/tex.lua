local opt = vim.opt
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.textwidth = 88
opt.colorcolumn = '89'

vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo[0][0].foldmethod = "expr"
