local ok_line, _ = pcall(require, "lualine")

if not ok_line then
  return
end

local function get_git_branch()
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\r\n'")
  vim.b.git_branch_name = branch
end

vim.api.nvim_create_autocmd('BufEnter', { callback = get_git_branch })

local function mode_section()
  local branch = vim.b.git_branch_name
  if branch ~= '' then
    return ' ' .. branch
  end
  return ' Not in git'
end

local function file_progress()
  local pos = vim.api.nvim_win_get_cursor(0)
  local total = vim.api.nvim_buf_line_count(0)
  local prog = math.floor(pos[1] / total * 100)
  return prog .. '%%' .. (' of %s'):format(total) .. ':%c'
end

local function get_diag_counts()
  local levels = vim.diagnostic.severity
  local name_map = { error = 0, warn = 0, info = 0, hint = 0 }
  local name2lv = {
    error = levels.ERROR, warn = levels.WARN, info = levels.INFO, hint = levels.HINT
  }
  for name, level in pairs(name2lv) do
    local count = #vim.diagnostic.get(0, { severity = level })
    name_map[name] = count
  end
  return name_map
end

-------------------
-- Cursor context -
-------------------
-- Helper function to extract the name from a node
local function get_node_name(node, bufnr)
  -- This varies by language, but common patterns:
  local name_child = node:field("name")[1]
  if name_child then
    return vim.treesitter.get_node_text(name_child, bufnr)
  end

  -- Try identifier child as fallback
  for child in node:iter_children() do
    if child:type() == "identifier" then
      return vim.treesitter.get_node_text(child, bufnr)
    end
  end

  return nil
end

local function get_cursor_context()
  local parser = vim.treesitter.get_parser()
  if not parser then
    return {}
  end

  -- Get the current buffer and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1 -- Convert to 0-indexed
  local col = cursor[2]

  local tree = parser:parse()[1]
  local root = tree:root()

  local node = root:descendant_for_range(row, col, row, col)
  local context_types = {
    "class_definition",
    "class_declaration",
    "function_definition",
    "function_declaration",
    "method_definition",
    "method_declaration",
    "arrow_function",
    "function_item", -- Rust
    "impl_item", -- Rust
    "struct_item", -- Rust
  }
  local context = {}

  -- Build context hierarchy by walking up the tree
  while node do
    local node_type = node:type()

    if vim.list_contains(context_types, node_type) then
      local name = get_node_name(node, bufnr)
      table.insert(context, 1, {
        type = node_type,
        name = name or "?",
        start_line = node:start(),
      })
    end
    node = node:parent()
  end

  return context
end

-- Format context as a string (e.g., "MyClass.myMethod.innerFunction")
local function format_context(context)
  local parts = {}
  for _, item in ipairs(context) do
    table.insert(parts, item.name)
  end
  return table.concat(parts, ".")
end

local function get_cursor_ctx()
  return format_context(get_cursor_context())
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
    lualine_x = { { 'diagnostics', sources = { get_diag_counts } } },
    lualine_y = { 'encoding', 'fileformat', 'filetype' },
    lualine_z = { file_progress },
  }
}
