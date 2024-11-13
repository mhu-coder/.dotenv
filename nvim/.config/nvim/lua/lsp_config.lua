local ok, wk = pcall(require, "which-key")
if not ok then
  return
end
local wk_utils = require("wk")

local diag_keymap = {
  { "e", vim.diagnostic.open_float, desc = "Jump into diagnostic window" },
  { "k", vim.diagnostic.goto_prev,  desc = "Go to previous diagnostic" },
  { "j", vim.diagnostic.goto_next,  desc = "Go to next diagnostic" },
  { "q", vim.diagnostic.setloclist, desc = "Add diagnostics to location list" },
}
wk_utils.add_prefix(diag_keymap, "<leader>d", "diagnostics")
wk.add(diag_keymap)

local on_attach = function(_, bufnr)
  local vlb = vim.lsp.buf
  local function print_worspace_folder()
    print(vim.inspect(vlb.list_workspace_folders()))
  end
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local go_keymap = {
    { "D", vlb.declaration,     desc = "Go to declaration" },
    { "d", vlb.definition,      desc = "Go to definition" },
    { "i", vlb.implementation,  desc = "Go to implementation" },
    { "t", vlb.type_definition, desc = "Go to type definition" },
    { "r", vlb.references,      desc = "Show all references in quickfix window" },
  }
  wk_utils.add_prefix(go_keymap, "g", "Go moves")
  wk.add(go_keymap)
  wk.add({
    { "K",     vlb.hover,          desc = "Show over information" },
    { "<C-k>", vlb.signature_help, desc = "Show signature help" },
  })
  local lsp_keymap = {
    { "wa", vlb.add_workspace_folder,    desc = "Add folder to workspace" },
    { "wr", vlb.remove_workspace_folder, desc = "Remove folder from workspace" },
    { "wp", print_worspace_folder,       desc = "Print folders in workspace" },
    { "r",  vlb.rename,                  desc = "Rename variable" },
    { "a",  vlb.code_action,             desc = "Select code action" },
  }
  wk_utils.add_prefix(lsp_keymap, "<leader>l", "LSP actions")
  wk.add(lsp_keymap)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local ruff_on_attach = function(client, _)
  client.server_capabilities.hoverProvider = false
end

local servers = {
  clangd = {},
  rust_analyzer = {},
  pyright = {
    settings = {
      pyright = { disableOrgnizeImports = true },
      python = { analysis = { ignore = { "*" } } },
    },
  },
  ruff = { on_attach = ruff_on_attach },
  texlab = {},
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = true },
      },
    },
  },
}

require('lazydev').setup()

-- mason setup
require('mason').setup()
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = servers[server_name].on_attach or on_attach,
      settings = servers[server_name].settings or {},
    }
  end,
}

servers["texlab"] = nil
local dap_servers = { "python", "rust" } -- DAP for rust also supports C and C++
require('mason-nvim-dap').setup({
  ensure_installed = dap_servers,
  automatic_installation = false,
})
