local function mode_section ()
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\r\n'")
  if branch ~= '' then
    return ' ' .. branch
  end
  return ' Not in git'
end

local function file_progress ()
  local pos = vim.api.nvim_win_get_cursor(0)
  local total = vim.api.nvim_buf_line_count(0)
  local prog = math.floor(pos[1] / total * 100)
  local res = pos[2] + 1 .. ' : ' .. total .. ' (' .. prog .. '%%)' 
  return res
end

--------------------------
-- Current function name -
--------------------------
local ts = require('nvim-treesitter')
local function get_cursor_ctx()
  opts = {
    type_patterns={'class', 'function', 'method', 'struct', 'impl'},
    separator='.',
    transform_fn=function(line)
      local res = line:gsub('%s*[%[%(%{%:]*%s*$', '')
      local res = vim.fn.split(vim.fn.split(res, '(')[1], ' ')
      return res[#res]
    end
  }
  return ts.statusline(opts)
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
    theme = 'powerline',
  },
  sections = {
    lualine_a = { mode_section },
    lualine_b = {'filename'},
    lualine_c = { get_cursor_ctx },
    lualine_x = { { 'diagnostics', sources = {'nvim_lsp'} } }, 
    lualine_y = {'encoding', 'fileformat', 'filetype' },
    lualine_z = { file_progress },
  }
}
