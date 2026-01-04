local langs = { 'c', 'cpp', 'lua', 'python', 'rust', 'latex' }
local ts = require('nvim-treesitter')
local installed = ts.get_installed()
local to_install = vim.iter(langs):filter(
  function(parser) return not vim.tbl_contains(installed, parser) end
):totable()
ts.install(to_install)

vim.api.nvim_create_autocmd("FileType", {
  desc = "User: enable treesitter highlighting",
  callback = function(ctx)
    -- highlights
    local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

    -- indent
    local noIndent = {}
    if hasStarted and not vim.list_contains(noIndent, ctx.match) then
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
