return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      completion = { enable = true },
      diagnostics = {
        enable = true,
        globals = { "vim" },
      },
      workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
      telemetry = { enable = true },
    },
  },
}
