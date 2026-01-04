local opt = vim.opt
opt.spell = true
opt.spelllang = 'en'
opt.textwidth = 88
opt.colorcolumn = '89'
if opt.formatoptions ~= nil then
  opt.formatoptions:remove('t')
end
