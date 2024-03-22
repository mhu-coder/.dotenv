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
    local search = vim.fn.input("String to search: ")
    return builtin.grep_string({search = search})
end

local wk = require("which-key")
local km = {
  f = {
    name = "Search through buffers and manuals",
    f = {builtin.find_files, "Find files"},
    g = {builtin.live_grep, "Live search grep"},
    s = {string_search, "Search string"},
    b = {builtin.buffers, "List currently opened buffers"},
    h = {builtin.help_tags, "List all help tags"},
  }
}
wk.register(km, {prefix="<leader>"})
