local extras = require("luasnip.extras")
return {
  s({trig="today", dscr="Today's date"}, {extras.partial(os.date, "%Y-%m-%d")})
}
