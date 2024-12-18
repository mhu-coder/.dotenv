local luasnip = require "luasnip"

local snip = luasnip.snippet
local snode = luasnip.snippet_node
local tnode = luasnip.text_node
local inode = luasnip.insert_node
local dnode = luasnip.dynamic_node
local cnode = luasnip.choice_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local indent_str = string.rep(" ", 4)

-- doc stuff adapted from github.com/molleweide/LuaSnip-snippets.nvim
local function doc_common(indent_level)
  local indent = string.rep(indent_str, indent_level)
  local nodes = {
    tnode({ indent .. '"""' }),
    inode(1, "One liner description."),
    cnode(2, {
      tnode({ "" }),
      snode(nil, {
        tnode({ "", "", "" }),
        inode(1, { indent .. "Long description" }),
      }),
    }),
  }
  return nodes, 2
end


local function py_func_doc(args, parent, ostate, indent_level)
  indent_level = indent_level or 1
  local nodes, n_fields = doc_common(indent_level)

  -- fill Args section
  local arr = {}
  local indent = string.rep(indent_str, indent_level)
  if args[1][1] ~= "" then
    table.insert(nodes, tnode({ "", "", indent .. "Args:" }))
    arr = vim.tbl_map(function(item)
      local trimed = vim.trim(item)
      return vim.split(trimed, ":")[1]
    end, vim.split(args[1][1], ',', true))
  end

  local next_indent = string.rep(indent_str, indent_level + 1)
  for idx, val in pairs(arr) do
    table.insert(nodes, tnode({ "", next_indent .. val .. ": " }))
    table.insert(nodes, inode(idx + 2, "Description for " .. val))
  end
  n_fields = n_fields + #arr

  if #args > 1 and args[2][1] ~= "None" then
    table.insert(nodes, tnode({ "", "", indent .. "Returns:", next_indent }))
    table.insert(nodes, inode(n_fields + 1, "Return description"))
    n_fields = n_fields + 1
  end
  table.insert(nodes, tnode({ "", indent .. '"""', indent }))

  local snippet = snode(nil, nodes)
  snippet.old_state = ostate or {}

  -- nodes, number of fields to fill
  return snippet
end

local function py_class_doc(_, _, old_state)
  -- indent_str = indent_str or "    "
  local nodes, _ = doc_common(1)
  table.insert(nodes, tnode({ "", indent_str .. '"""', "" }))
  local snippet = snode(nil, nodes)
  snippet.old_state = old_state or {}
  return snippet
end


local function documented_fn()
  return fmt(
    "def {}({}) -> {}:\n{}",
    { inode(1, "func_name"), inode(2),
      inode(3, "None"),
      dnode(4, py_func_doc, { 2, 3 }) }
  )
end

local function clic()
  return fmt([[
  from cyclopts import App


  _app = App()

  @_app.command()
  {}


  if __name__ == "__main__":
  {}_app()
  ]], { inode(1, "main_function"), tnode({ indent_str }) }
  )
end

local function bare_cli()
  local content = [[
  """{}"""
  import argparse


  def {}(args=None):
  ^tparsed = _parse_args(args)
  ^t{}


  def _parse_args(args):
  ^tparser = argparse.ArgumentParser(
  ^t^tdescription=__doc__,
  ^t^tformatter_class=argparse.RawDescriptionHelpFormatter
  ^t)
  ^t{}
  ^treturn parser.parse_args(args)


  if __name__ == "__main__":
  ^t{}()
  ]]
  content = content:gsub("%^t", indent_str)
  return fmt(content, {
    inode(1, { "Program Description." }),
    inode(2, "fn_name"),
    inode(3, { "# Program body" }),
    -- _parse_args
    inode(4, { "# Parse arguments" }),
    -- if __name__
    dnode(5, function(args)
      return snode(nil, { tnode(args[1][1]) })
    end, { 2 }),
  })
end


return {
  luasnip.parser.parse_snippet(
    { trig = "mn", dscr = "Creates main guard" },
    'if __name__ == "__main__":\n' .. indent_str
  ),
  luasnip.parser.parse_snippet(
    { trig = "tfx", dscr = "PyTest fixture" },
    "@pytest.fixture${1:(scope=\"${2|function,class,module,package,session|}\")}"
  ),
  snip(
    { trig = "tfpar", dscr = "PyTest parametrize for functions" },
    fmt(
      "@pytest.mark.parametrize(\"{}\",[{}])\n" ..
      "def test_{}({}):\n{}",
      { inode(1), inode(2), inode(3), rep(1), inode(4) }
    )),
  snip(
    { trig = "tmpar", dscr = "PyTest parametrize for methods" },
    fmt(
      "@pytest.mark.parametrize(\"{}\",[{}])\n" ..
      "def test_{}(self, {}):\n{}",
      { inode(1), inode(2), inode(3), rep(1), inode(4) }
    )),
  snip({ trig = "cls", dscr = "Documented class" }, fmt(
    "class {}:\n{}\n" .. indent_str .. "def __init__(self, {}):\n{}",
    { inode(1, "ClassName"), dnode(2, py_class_doc), inode(3),
      dnode(4, py_func_doc, { 3 }, { user_args = { 2 } }) }
  )),
  snip({ trig = "fn", dscr = "Documented function" }, documented_fn()),
  snip({ trig = "meth", dscr = "Documented method" }, fmt(
    "def {}(self, {}) -> {}:\n{}",
    { inode(1, "func_name"), inode(2),
      inode(3, "None"),
      dnode(4, py_func_doc, { 2, 3 }, { user_args = { 1 } }) }
  )),
  snip({ trig = "__in", dscr = "Class init" }, fmt(
    indent_str .. "def __init__(self, {}):\n{}",
    { inode(1), dnode(2, py_func_doc) }
  )),
  snip({ trig = "cli", dscr = "Basic CLI" }, bare_cli()),
  snip({ trig = "clic", dscr = "CLI with cyclopts" }, clic()),
}
