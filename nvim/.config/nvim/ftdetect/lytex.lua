vim.cmd([[
  augroup lytex_ft
    autocmd!
    autocmd BufNewFile,BufRead *.lytex set syntax=tex filetype=tex
  augroup END
]])
