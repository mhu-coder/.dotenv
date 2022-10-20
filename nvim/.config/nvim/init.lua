-- Package manager and packages
if require('plugins') then
  return
end

require('lsp_config')

local colorscheme = "one"

vim.cmd("colorscheme " .. colorscheme)

-- Other vim config stuff
vim.cmd([[
  set hidden
  set encoding=utf-8
  syntax on
  set shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent smartindent
  set number relativenumber cursorline
  set textwidth=80 colorcolumn=81
  set termguicolors
  set background=dark
  highlight ColorColumn guibg='Red'
  highlight WinSeparator guibg=None
]])


-- Common config
vim.g.python3_host_prog = '/usr/bin/python3'

-- Search config
vim.cmd("set incsearch")
local nnoremaps = {
  ["<ESC>"] = ':set nohlsearch<CR><ESC>',
  ["/"] = ':set hlsearch<CR>/',
  ["?"] = ':set hlsearch<CR>?',
  ["*"] = ':set hlsearch<CR>*',
  n = ':set hlsearch<CR>n',
  N = ':set hlsearch<CR>N',
}
for orig, new in pairs(nnoremaps) do
  vim.api.nvim_set_keymap('n', orig, new, { noremap = true })
end
