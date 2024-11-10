local ok, telescope = pcall(require, "telescope")
if not ok then
    return
end

telescope.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            case_mode = "smart_case",
        },
    },
}
require('telescope').load_extension('fzf')

local builtin = require "telescope.builtin"
local string_search = function()
    local search = vim.fn.input("String to search: ")
    return builtin.grep_string({ search = search })
end

local wk_utils = require("wk")
local wk = require("which-key")
local km = {
    { "f", builtin.find_files, desc = "Find files" },
    { "g", builtin.live_grep,  desc = "Live search grep" },
    { "s", string_search,      desc = "Search string" },
    { "b", builtin.buffers,    desc = "List currently opened buffers" },
    { "h", builtin.help_tags,  desc = "List all help tags" },
}
wk.add(wk_utils.add_prefix(km, "<leader>f", "File"))
