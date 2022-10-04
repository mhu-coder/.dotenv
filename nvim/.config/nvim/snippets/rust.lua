local luasnip = require "luasnip"

local snip = luasnip.snippet
local snode = luasnip.snippet_node
local tnode = luasnip.text_node
local inode = luasnip.insert_node
local fnode = luasnip.function_node
local dnode = luasnip.dynamic_node
local cnode = luasnip.choice_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep


return {
    snip({trig="modtest", dscr="Module test"}, fmt(
        [[
            #[cfg(test)]
            mod tests {{
            {}
                {}
            }}
        ]],
        { cnode(1, {tnode("    use super::*;"), tnode("")}), inode(0) }
    )),
    snip({trig="test", dscr="Test"}, fmt(
        [[
            #[test]
            fn {}({}) {{
                {}
            }}
        ]],
        {inode(1), inode(2), inode(0)}
    )),
}
