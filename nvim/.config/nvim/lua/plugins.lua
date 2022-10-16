-- Plugin config. Requires packer to be available

local res = require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'saadparwaiz1/cmp_luasnip'
  -- DAP
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'mfussenegger/nvim-dap-python'

  -- Code exploration
  use {'nvim-telescope/telescope.nvim', tag='0.1.0',
        requires = {{'nvim-lua/plenary.nvim'}}}
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run='cmake -S . -B build -DCMAKE_BUILD_TYPE=Release ' ..
    '&& cmake --build build --config Release ' ..
    '&& cmake --install build --prefix build'
  }
  use {'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end}

  -- Editor appearance
  use 'rakr/vim-one'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use 'kyazdani42/nvim-web-devicons'
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- Git
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'

  -- Misc
  use 'tpope/vim-surround'
  use 'vimwiki/vimwiki'
end)

vim.cmd("PackerInstall")

require('lsp_config')

return res
