local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local function git_plugs()
  return {
    'tpope/vim-fugitive',
    {
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },
    { -- Add indentation guides even on blank lines
      'lukas-reineke/indent-blankline.nvim',
      main = "ibl",
      -- Enable `lukas-reineke/indent-blankline.nvim`
      opts = {
        indent = { char = '┊' },
        whitespace = { remove_blankline_trail = false },
      },
    },
  }
end

local function ui_plugs()
  return {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'kyazdani42/nvim-web-devicons' }
    },
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  }
end

local function code_plugs()
  return {
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Auto install LSPs to stdpath for nvim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        -- Useful status updates for LSP
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim', tag = "legacy", event = "LspAttach", opts = {} },
        -- Additional lua configuration, makes nvim stuff amazing!
        'folke/neodev.nvim',
      },
    },
    {
      'mfussenegger/nvim-dap',
      dependencies = {
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',
      },
    },
    {
      'simrat39/rust-tools.nvim',
    },
    {
      'rcarriga/nvim-dap-ui',
      dependencies = {
        "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"
      },
    },
    {
      'mfussenegger/nvim-dap-python'
    },
    { -- Autocompletion
      'hrsh7th/nvim-cmp',
      -- 'saadparwaiz1/cmp_luasnip'  for completion source if wanted
      dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip' },
    },
    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },
    { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
      config = function()
        pcall(require('nvim-treesitter.install').update { with_sync = true })
      end,
    },
    { -- Autoformat
      'stevearc/conform.nvim',
      opts = {},
    },
  }
end

local function util_plugs()
  return {
    { 'folke/which-key.nvim', opts = {} },
    -- Fuzzy Finder (files, lsp, etc)
    {
      'nvim-telescope/telescope.nvim',
      version = '*',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim', opts = {} },
  }
end

require('lazy').setup({
  git_plugs(),
  ui_plugs(),
  code_plugs(),
  util_plugs(),
}, {})
