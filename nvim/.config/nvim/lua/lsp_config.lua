-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local wk = require("which-key")
local diag_keymap = {
  name = "diagnostic",
  e = {vim.diagnostic.open_float, "Jump into diagnostic window"},
  k = {vim.diagnostic.goto_prev, "Go to previous diagnostic"},
  j = {vim.diagnostic.goto_next, "Go to next diagnostic"},
  q = {vim.diagnostic.setloclist, "Add diagnostics to location list"},
}
wk.register(diag_keymap, {prefix = "<leader>d"})

local on_attach = function(_, bufnr)
  local vlb = vim.lsp.buf
  local function print_worspace_folder()
    print(vim.inspect(vlb.list_workspace_folders()))
  end
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local go_keymap = {
    name = "Go moves -- Requires LSP",
    D = {vlb.declaration, "Go to declaration"},
    d = {vlb.definition, "Go to definition"},
    i = {vlb.implementation, "Go to implementation"},
    t = {vlb.type_definition, "Go to type definition"},
    r = {vlb.references, "Show all references in quickfix window"},
  }
  wk.register(go_keymap, {prefix = "g"})
  wk.register({
    K = {vlb.hover, "Show over information"},
    ["<C-k>"] = {vlb.signature_help, "Show signature help"},
  })
  local lsp_keymap = {
    name = "LSP actions",
    wa = {vlb.add_workspace_folder, "Add folder to workspace"},
    wr = {vlb.remove_workspace_folder, "Remove folder from workspace"},
    wp = {print_worspace_folder, "Print folders in workspace"},
    r = {vlb.rename, "Rename variable"},
    a = {vlb.code_action, "Select code action"},
  }
  wk.register(lsp_keymap, {prefix = "<leader>l"})

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
local dap_servers = {"python", "rust"}  -- DAP for rust also supports C and C++
require('mason-nvim-dap').setup({
  ensure_installed = dap_servers,
  automatic_installation = false,
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
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-c>'] = cmp.mapping.abort(),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
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

