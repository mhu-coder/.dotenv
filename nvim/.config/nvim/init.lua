-- nvim init.lua

-- Clear useless default keymaps
local useless_keys = { "<C-c>" }
for _, val in pairs(useless_keys) do
  vim.api.nvim_set_keymap("i", val, "<Nop>", { noremap = true })
end

-- Package manager and packages
require('plugins')
require('lsp')


vim.cmd.colorscheme "catppuccin"

-- Other vim config stuff
local opt = vim.opt
opt.wildignore:append { '*.o', '*.a', '*.so', '__pycache__', '*.egg-info' }
opt.hidden = true
opt.encoding = 'utf-8'
opt.syntax = 'on'
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.wrap = true
opt.background = 'dark'
opt.colorcolumn = '80'
opt.signcolumn = "yes:1"
opt.winborder = 'rounded'
opt.laststatus = 3
-- TODO: runtimepath+=/usr/local/lilypond-2.24.2/share/lilypond/2.24.2/vim

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
