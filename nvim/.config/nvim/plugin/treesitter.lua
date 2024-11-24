local langs = { 'c', 'cpp', 'lua', 'python', 'rust', 'latex', 'vim', 'vimdoc' }
require('nvim-treesitter.configs').setup {
  modules = {},
  ensure_installed = langs,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-\\>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['ia'] = '@parameter.inner',
        ['aa'] = '@parameter.outer',
        ['if'] = '@function.inner',
        ['af'] = '@function.outer',
        ['ic'] = '@class.inner',
        ['ac'] = '@class.outer',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']w'] = 'function.outer',
        [']W'] = '@class.outer',
      },
      goto_next_end = {
        [']e'] = '@function.outer',
        [']E'] = '@class.outer',
      },
      goto_previous_start = {
        ['[w'] = '@function.outer',
        ['[W'] = '@class.outer',
      },
      goto_previous_end = {
        ['[e'] = '@function.outer',
        ['[E'] = '@class.outer',
      },
    },
    swap = { enable = false },
  },
  sync_install = false,
  ignore_install = {},
}

-- configure folds to rely on treesitter
vim.cmd([[
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
  set nofoldenable
]])
