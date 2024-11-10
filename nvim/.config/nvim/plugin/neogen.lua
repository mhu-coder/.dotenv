local ok, ng = pcall(require, "neogen")

if not ok then
  return
end

local config = {
  snippet_engine = "luasnip",
}
ng.setup(config)


local wk = require("which-key")
local wk_utils = require("wk")
local km = { { "d", ng.generate, desc = "Generate annotation" } }
wk.add(wk_utils.add_prefix(km, "<leader>n", "Annotations"))
