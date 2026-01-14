local function on_exit(plug_name)
  local res = function(obj)
    if obj.code ~= 0 then
      local msg = ('Failed to compile %s'):format(plug_name)
      local err_lv = vim.log.levels.ERROR
      vim.notify(msg, err_lv)
      vim.notify(obj.stdout, err_lv)
      vim.notify(obj.stderr, err_lv)
    end
  end
  return res
end

local function install_telescope_fzf(event)
  local cmd = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
  -- wait to prevent install of telescope without fzf
  local _ = vim.system(
    { 'bash', '-c', cmd },
    { cwd = event.data.path },
    on_exit(event.data.spec.name)
  ):wait()
end

local function install_blink(event)
  local cmd = { 'bash', '-c', 'cargo build --release' }
  -- wait to prevent erroneous warning about missing binary for fuzzy search
  local _ = vim.system(cmd, { cwd = event.data.path }, on_exit(event.data.spec.name)):wait()
end

local custom_install = {
  ['telescope-fzf-native.nvim'] = install_telescope_fzf,
  ['blink.cmp'] = install_blink
}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local extra_install = custom_install[ev.data.spec.name]
    if extra_install then
      vim.notify_once(
        'Running extra install for ' .. ev.data.spec.name, vim.log.levels.INFO
      )
      extra_install(ev)
    end
  end,
})

vim.pack.add({
  -- code plugins
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  -- 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  { -- snippets
    src = 'https://github.com/L3MON4D3/LuaSnip',
    version = vim.version.range('v2.0 - v3.0'),
  },
  'https://github.com/saghen/blink.cmp', -- native completion only supports 1 source
  'https://github.com/danymat/neogen',   -- code annotation
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/stevearc/conform.nvim', -- code formatting
  -- 'https://github.com/mfussenegger/nvim-dap',
  -- 'https://github.com/rcarriga/nvim-dap-ui',
  -- 'https://github.com/mfussenegger/nvim-dap-python',
  -- file search
  'https://github.com/nvim-lua/plenary.nvim', -- for telescope
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  -- keymaps
  'https://github.com/folke/which-key.nvim',
  -- UI
  'https://github.com/catppuccin/nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
})
