local ok, conform = pcall(require, "conform")

if not ok then
  return
end

local formatters_by_ft = {
  lua = { 'stylua' },
  python = { 'isort', 'black' },
}
conform.setup({
  notify_on_error = false,
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
  formatters_by_ft = formatters_by_ft,
})
