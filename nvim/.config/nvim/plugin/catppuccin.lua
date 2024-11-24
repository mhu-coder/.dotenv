local ok, cat = pcall(require, "catppuccin")

if not ok then
  return
end

cat.setup({ flavour = "macchiato" })
