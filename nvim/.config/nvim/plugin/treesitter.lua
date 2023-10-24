local langs = {'c', 'cpp', 'lua', 'python', 'rust', 'latex', 'vim', 'help'}
require('nvim-treesitter.configs').setup {
  ensure_installed = langs,
  auto_install = true,
  highlight = {enable = true},
  indent = { enable = true, disable = {'python'} },
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
    swap = {
      enable = true,
      swap_next = {
        ['<leader>s'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>S'] = '@parameter.inner',
      },
    },
  },
}
