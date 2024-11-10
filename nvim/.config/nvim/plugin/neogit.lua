local ok, neogit = pcall(require, "neogit")
local wk_ok, wk = pcall(require, "which-key")
if not ok or not wk_ok then
  vim.api.nvim_command('echo "Failed to init which-key and or neogit"')
  return
end

local wk_utils = require("wk")
local km = {
  { "g", neogit.open, desc = "Open Neogit" },
}
wk.add(wk_utils.add_prefix(km, "<leader>g", "Neogit"))
