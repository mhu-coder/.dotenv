local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

telescope.setup {
    extensions = {
        fzf = {
            fuzzy=true,
            override_generic_sorter=true,
            case_mode="smart_case",
        },
    },
}
require('telescope').load_extension('fzf')

local builtin = require "telescope.builtin"
local string_search = function()
    local search = vim.fn.input("Search: ")
    return builtin.grep_string({search = search})
end
local keymaps = {
    ['<leader>ff']=builtin.find_files,
    ['<leader>fg']=builtin.live_grep,
    ['<leader>fs']=string_search,
    ['<leader>fb']=builtin.buffers,
    ['<leader>fh']=builtin.help_tags,
}
local opts = { noremap=true, silent=true }
for keymap, fun in pairs(keymaps) do
    vim.keymap.set('n', keymap, fun, opts)
end
