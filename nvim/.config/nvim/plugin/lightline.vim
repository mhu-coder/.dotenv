let g:lightline = {
  \ 'colorscheme': 'powerline',
  \ 'active': {
  \    'left': [ ['mode', 'paste'],
  \              ['filename'] ],
  \    'right': [ ['lsp_error', 'lsp_warning'],
  \               ['lineinfo'],
  \               ['fileinfo'] ]
  \ },
  \ 'component': {
  \    'fileinfo': '%{&filetype} (%{&fileencoding? &fileencoding:&encoding})',
  \    'lineinfo': '%l/%L: %c (%p%%)'
  \ },
  \ 'component_function': {
  \    'mode': 'LightlineGitBranch',
  \    'filename': 'LightlineFilename',
  \ },
  \ 'component_expand': {
  \    'lsp_error': 'LspError',
  \    'lsp_warning': 'LspWarning',
  \ },
  \ 'component_type': {
  \    'lsp_error': 'error',
  \    'lsp_warning': 'warning',
  \ },
\}
set noshowmode

function! LightlineGitBranch()
    return FugitiveHead() !=# '' ? '↱ ' . FugitiveHead() : '[None]'
endfunction

function! LightlineLineinfo()
    return lineinfo() . percent()
endfunction

function! LightlineFilename()
    let buf_num = bufnr('%') !=# -1 ? bufnr('%') : ''
    let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
    let modified = &modified ? ' +' : ''
    let filepath = glob('%')
    let locked = filepath !=# '' && filewritable(filepath) ==# 0 ? '🔒 ' : ''
    return buf_num . ': ' . locked . filename . modified
endfunction

function! LspError()
    if luaeval('table.getn(vim.lsp.buf_get_clients()) > 0')
        return luaeval("require('statusline').error_status()")
    endif
    return ''
endfunction

function! LspWarning()
    if luaeval('table.getn(vim.lsp.buf_get_clients()) > 0')
        return luaeval("require('statusline').warning_status()")
    endif
    return ''
endfunction

autocmd User LspDiagnosticsChanged call lightline#update()
autocmd BufWrite * :call lightline#update()
