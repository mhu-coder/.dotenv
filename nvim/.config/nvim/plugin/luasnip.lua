local ok, luasnip = pcall(require, 'luasnip')

if not ok then
  return
end

local types = require "luasnip.util.types"

luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "← Current choice", "Error" } }
      }
    }
  }
}

local wk = require("which-key")

local km = {
  {
    "<c-k>",
    function() if luasnip.jumpable() then luasnip.jump(1) end end,
    desc = "Go to next node",
  },
  {
    "<c-j>",
    function() if luasnip.jumpable(-1) then luasnip.jump(-1) end end,
    desc = "Go to previous node",
  },
  {
    "<c-l>",
    function() if luasnip.choice_active() then luasnip.change_choice(1) end end,
    desc = "Go to next choice",
  },
  {
    "<c-h>",
    function() if luasnip.choice_active() then luasnip.change_choice(-1) end end,
    desc = "Go to previous choice",
  },
}
wk.add({ mode = { "i", "s" }, km })

vim.keymap.set(
  "n",
  "<leader><leader>s",
  "<cmd>source ~/.config/nvim/plugin/luasnip.lua<CR>"
)

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/snippets" } })
