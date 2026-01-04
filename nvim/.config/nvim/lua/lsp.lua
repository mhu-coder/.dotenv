local lsps = {
  'bashls', 'lua_ls', 'pyright'
}
vim.lsp.enable(lsps)
vim.diagnostic.config({ virtual_text = true })

-------------
-- Keymaps --
-------------
local ok, wk = pcall(require, "which-key")
if not ok then
  return
end
local wk_utils = require("wk")

local goto_prev = function()
  vim.diagnostic.jump({ count = -1, float = true })
end

local goto_next = function()
  vim.diagnostic.jump({ count = 1, float = true })
end

local diag_keymap = {
  { "e", vim.diagnostic.open_float, desc = "Jump into diagnostic window" },
  { "k", goto_prev,                 desc = "Go to previous diagnostic" },
  { "j", goto_next,                 desc = "Go to next diagnostic" },
  { "q", vim.diagnostic.setloclist, desc = "Add diagnostics to location list" },
}
wk_utils.add_prefix(diag_keymap, "<leader>d", "diagnostics")
wk.add(diag_keymap)

local on_attach = function(bufnr)
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

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    on_attach(args.buf)
  end,
})
