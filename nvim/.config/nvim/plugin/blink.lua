local ok, blink = pcall(require, "blink.cmp")

if not ok then
  return
end

blink.setup({
  signature = { enabled = true },
  snippets = { preset = 'luasnip' },
  sources = {
    default = { 'lsp', 'snippets', 'buffer' },
  },
  keymap = { -- passthrough keys below
    ['<c-k>'] = { 'fallback' },
    ['<c-j>'] = { 'fallback' },
  }
})
