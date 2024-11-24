-- nvim init.lua

-- Clear useless default keymaps
local useless_keys = { "<C-c>" }
for _, val in pairs(useless_keys) do
  vim.api.nvim_set_keymap("i", val, "<Nop>", { noremap = true })
end

-- Package manager and packages
require('plugins')
require('lsp_config')

vim.cmd("colorscheme catppuccin")

-- Other vim config stuff
vim.cmd([[
  set hidden
  set encoding=utf-8
  syntax on
  set shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent smartindent
  set number relativenumber cursorline
  set textwidth=88 colorcolumn=89
  set termguicolors
  set background=dark
  highlight ColorColumn guibg='Red'
  highlight WinSeparator guibg=None
  set laststatus=3
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
