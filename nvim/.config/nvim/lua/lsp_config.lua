-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local diagnostic_keymap = {
  ['<leader>e'] = vim.diagnostic.open_float,
  ['<leader>k'] = vim.diagnostic.goto_prev,
  ['<leader>j'] = vim.diagnostic.goto_next,
  ['<leader>q'] = vim.diagnostic.setloclist,
}
for key, cmd in pairs(diagnostic_keymap) do
  vim.keymap.set('n', key, cmd, { noremap=true, silent=true })
end

local on_attach = function(_, bufnr)
  local vlb = vim.lsp.buf
  local function print_worspace_folder()
    print(vim.inspect(vlb.list_workspace_folders()))
  end
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local lsp_kmap = {
    ['gD'] = vlb.declaration,
    ['gd'] = vlb.definition,
    ['gi'] = vlb.implementation,
    ['gt'] = vlb.type_definition,
    ['gr'] = vlb.references,
    ['K'] = vlb.hover,
    ['<C-k>'] = vlb.signature_help,
    ['<leader>wa'] = vlb.add_workspace_folder,
    ['<leader>wr'] = vlb.remove_workspace_folder,
    ['<leader>wl'] = print_worspace_folder,
    ['<leader>rn'] = vlb.rename,
    ['<leader>ca'] = vlb.code_action,
  }
  for key, cmd in pairs(lsp_kmap) do
    vim.keymap.set('n', key, cmd, {noremap=true, silent=true, buffer=bufnr})
  end

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local servers = {
  clangd = {},
  rust_analyzer = {},
  pyright = {},
  texlab = {},
  lua_ls = {
    Lua = {
      workspace = {checkThirdParty = false},
      telemetry = {enable = true},
    },
  },
}

require('neodev').setup()

-- mason setup
require('mason').setup()
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}
mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

servers["texlab"] = nil
require('mason-nvim-dap').setup({
  ensure_installed = vim.tbl_keys(servers)
})

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-c>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

