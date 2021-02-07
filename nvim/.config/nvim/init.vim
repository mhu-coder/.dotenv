if empty(glob('$HOME/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

call plug#begin()
" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

" Editor appearance
Plug 'drewtempelmeyer/palenight.vim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'itchyny/lightline.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Python
Plug 'tmhedberg/SimpylFold'

" Misc
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'

" Previews
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app && npm install'}
call plug#end()

set hidden
syntax on

let $RTP=split(&runtimepath, ',')[0]

" Common config
let g:python3_host_prog = '$HOME/miniconda3/bin/python3.8' 
set shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent smartindent
set number relativenumber cursorline
set textwidth=80 colorcolumn=81

" Colors
set termguicolors
set background=dark
colorscheme palenight
highlight ColorColumn guibg='Red'

" LSP config
lua require("lsp_config")
" completion config
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
inoremap <expr> <Tab>     pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab>   pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Diagnostic config
highlight LspDiagnosticsDefaultError guifg='Red'
highlight LspDiagnosticsDefaultWarning guifg='Orange'

" Custom commands
" Search config
set incsearch
nnoremap <C-[> :set nohlsearch<CR><C-[>
nnoremap / :set hlsearch<CR>/
nnoremap * :set hlsearch<CR>*
nnoremap n :set hlsearch<CR>n
nnoremap N :set hlsearch<CR>N

" Toggle uppercase current word/Word
" <leader>u is used as the prefix for my custom commands
nnoremap <leader>uc viw~e
nnoremap <leader>uC viW~E
