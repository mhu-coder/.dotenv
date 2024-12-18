local ok_line, _ = pcall(require, "lualine")

if not ok_line then
  return
end

local function mode_section()
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\r\n'")
  if branch ~= '' then
    return ' ' .. branch
  end
  return ' Not in git'
end

local function file_progress()
  local pos = vim.api.nvim_win_get_cursor(0)
  local total = vim.api.nvim_buf_line_count(0)
  local prog = math.floor(pos[1] / total * 100)
  local res = pos[2] + 1 .. ' : ' .. total .. ' (' .. prog .. '%%)'
  return res
end

--------------------------
-- Current function name -
--------------------------
local ok_ts, ts = pcall(require, "nvim-treesitter")
local get_cursor_ctx = function() return '' end

if ok_ts then
  local ts_parser = require('nvim-treesitter.parsers')
  get_cursor_ctx = function()
    if not ts_parser.has_parser() then
      return ''
    end

    local pattern = { 'class', 'function', 'method' }
    local extra_patterns = {
      rust = { 'struct', 'impl' },
    }

    local ft = vim.bo.filetype
    if extra_patterns[ft] ~= nil then
      for _, val in ipairs(extra_patterns[ft]) do
        table.insert(pattern, #pattern + 1, val)
      end
    end

    local opts = {
      type_patterns = pattern,
      separator = '.',
      transform_fn = function(line)
        local res = line:gsub('%s*[%[%(%{%:]*%s*$', '')
        res = vim.fn.split(vim.fn.split(res, '(')[1], ' ')
        return res[#res]
      end
    }
    return ts.statusline(opts)
  end
end

-----------------
-- Plugin setup -
-----------------
require('lualine').setup {
  options = {
    always_divide_middle = false,
    globalstatus = true,
    section_separators = '',
    component_separators = '',
    theme = 'catppuccin',
  },
  sections = {
    lualine_a = { mode_section },
    lualine_b = { 'filename' },
    lualine_c = { get_cursor_ctx },
    lualine_x = { { 'diagnostics', sources = { 'nvim_lsp' } } },
    lualine_y = { 'encoding', 'fileformat', 'filetype' },
    lualine_z = { file_progress },
  }
}
