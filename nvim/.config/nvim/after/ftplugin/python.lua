local opt = vim.opt
opt.textwidth = 88
opt.colorcolumn = '89'
if opt.formatoptions ~= nil then
  opt.formatoptions:remove({ 't' })
end
