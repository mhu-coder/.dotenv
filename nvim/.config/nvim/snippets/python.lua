local luasnip = require "luasnip"
local luasp = luasnip.parser

local snip = luasnip.snippet
local snode = luasnip.snippet_node
local tnode = luasnip.text_node
local inode = luasnip.insert_node
local dnode = luasnip.dynamic_node
local cnode = luasnip.choice_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local indent_str = string.rep(" ", 4)

------------------------
-- CLI script snippet --
------------------------
local function has_uv()
  local res = false
  vim.system(
    { "uv", "--help" },
    function(obj)
      res = (obj.code == 0)
    end
  ):wait()
  return res
end

local function get_cli_tool()
  -- check if using system python to manage package
  local cmd = { 'python', '-m', 'pip', 'list' }
  local pip_res = vim.system(cmd):wait()
  local base_cmd = { 'pip', 'show' }
  if pip_res.code ~= 0 then
    if has_uv() then
      table.insert(base_cmd, 1, 'uv')
    else
      return 'argparse'
    end
  end

  -- Prefer cyclopts > typer > argparse when available
  for _, pkg in ipairs({ 'cyclopts', 'typer' }) do
    cmd = vim.deepcopy(base_cmd)
    table.insert(cmd, pkg)
    local tmp = vim.system(cmd):wait()
    if tmp.code == 0 then
      return pkg
    end
  end
  return 'argparse'
end

local function make_cyclopts_snip()
  return fmt(([[from cyclopts import App

_app = App()


@_app.command
def {}({}):
^t{}


if __name__ == "__main__":
^t_app()
]]):gsub('%^t', indent_str),
    { inode(1, "command"), inode(2, 'arguments'), inode(3, 'pass') }
  )
end

local function make_typer_snip()
  return fmt(([[from typer import Typer

_app = Typer()


@_app.command()
def {}({}):
^t{}


if __name__ == "__main__":
^t_app()
]]):gsub('%^t', indent_str),
    { inode(1, "command"), inode(2, 'arguments'), inode(3, 'pass') }
  )
end

local function make_argparse_snip()
  local content = [["""{}"""
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

local function get_cli_snip()
  local tool = get_cli_tool()
  local cli_tmpl_map = {
    ['cyclopts'] = make_cyclopts_snip,
    ['typer'] = make_typer_snip,
    ['argparse'] = make_argparse_snip,
  }
  return cli_tmpl_map[tool]()
end


---------------------
-- Pytest snippets --
---------------------
local function get_pytest_function()
  local tmpl = [[@pytest.mark.parametrize("{}",[{}])
def test_{}({}):
^t{}
]]
  return fmt(
    tmpl:gsub('%^t', indent_str),
    { inode(1), inode(2), inode(3), rep(1), inode(4) }
  )
end

local function get_pytest_method()
  local tmpl = [[@pytest.mark.parametrize("{}",[{}])
def test_{}(self, {}):
^t{}
]]
  return fmt(
    tmpl:gsub('%^t', indent_str),
    { inode(1), inode(2), inode(3), rep(1), inode(4) }
  )
end

local function create_fixture()
  return "@pytest.fixture${1:(scope=\"${2|function,class,module,package,session|}\")}"
end


return {
  snip({ trig = 'cli', dscr = 'Command line template' }, get_cli_snip()),
  snip({ trig = 'tstfn', dscr = 'PyTest parametrize function' }, get_pytest_function()),
  snip({ trig = 'tstmt', dscr = 'PyTest parametrize function' }, get_pytest_method()),
  luasp.parse_snippet({ trig = 'tstfx', descr = 'Pytest fixture'}, create_fixture()),
}
