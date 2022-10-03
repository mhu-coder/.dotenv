local luasnip = require 'luasnip'
local types = require "luasnip.util.types"

luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = {{ "← Current choice", "Error" }}
      }
    }
  }
}

-- keymap
vim.keymap.set({"i", "s"}, "<c-k>", function ()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, {silent=true})
vim.keymap.set({"i", "s"}, "<c-j>", function ()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, {silent=true})
vim.keymap.set({"i", "s"}, "<c-l>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end)
vim.keymap.set({"i", "s"}, "<C-H>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(-1)
  end
end)
vim.keymap.set(
  "n",
  "<leader><leader>s",
  "<cmd>source ~/.config/nvim/plugin/luasnip.lua<CR>"
)

require("luasnip.loaders.from_lua").load({paths="~/.config/nvim/snippets"})
