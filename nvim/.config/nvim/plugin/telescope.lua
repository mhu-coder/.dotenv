local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local pickers     = require("telescope.pickers")
local finders     = require("telescope.finders")
local make_entry  = require("telescope.make_entry")
local conf        = require("telescope.config").values

local live_ftgrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end
      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }
      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end
      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end
      return vim.iter({
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      }):flatten():totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Grep on file matching pattern",
    finder = finder,
    previewer = conf.grep_previewer(opts),
    sorter = require("telescope.sorters").empty(),
  }):find()
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
  { "g", live_ftgrep,        desc = "Live search grep" },
  { "s", string_search,      desc = "Search string" },
  { "b", builtin.buffers,    desc = "List currently opened buffers" },
  { "h", builtin.help_tags,  desc = "List all help tags" },
}
wk.add(wk_utils.add_prefix(km, "<leader>f", "File"))
wk.add({ "<leader>dd", "<cmd>Telescope diagnostics<CR>", desc = "Show diagnostics" })
