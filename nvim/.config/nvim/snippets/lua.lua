local luasnip = require "luasnip"

local s = luasnip.s

local fmt = require("luasnip.extras.fmt").fmt
local inode = luasnip.insert_node
local fnode = luasnip.function_node
local rep = require("luasnip.extras").rep

local function auto_req_name(import_name)
  local parts = vim.split(import_name[1][1], ".", true)
  return parts[#parts] or ""
end

return {
  parse("lf", "local function $1($2)\n    $0\nend"),
  s("req", fmt(
    "local {} = require \"{}\"",
    {fnode(auto_req_name, { 1 }), inode(1)}
  )),
}
