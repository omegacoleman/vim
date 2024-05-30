let g:skip_defaults_vim = 1

syntax on
filetype plugin on

set nocompatible

set bs=2
set ai
set history=500
set ruler
set viminfo='20,\"500
set nomodeline
set fileencodings=ucs-bom,utf-8,default,latin1
set hlsearch

try
  set termguicolors
catch /.*/
  " bad luck but most plugins handle it
endt

set laststatus=2
set showtabline=2
set noshowmode
let g:mapleader = ","
set expandtab
set sw=2
set ts=2
set backspace=indent,eol,start
set nofoldenable
set ttm=10
set hidden
set number

if has('gui_running')
  set guioptions-=e
  set guioptions-=m
  set guioptions-=T
endif

if stridx($LANG, 'utf8') != -1
  set list
  set listchars=tab:╟╶,eol:\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨
  set showbreak=↪\ 
endif

packadd lightline.vim
packadd lightline-bufferline
packadd rainglow-vim
packadd vim9-stargate
packadd lsp
packadd litesnip

let g:lightline = {
\ 'colorscheme': 'materia',
\ 'active': {
\   'left': [
\     [ 'mode', 'paste' ],
\     [ 'readonly', 'filename', 'modified' ]
\   ]
\ },
\ 'tabline': {
\   'left': [ ['buffers'] ],
\   'right': [ ['close'] ]
\ },
\ 'component_expand': {
\   'buffers': 'lightline#bufferline#buffers'
\ },
\ 'component_type': {
\   'buffers': 'tabsel'
\ }
\}

colorscheme darkside
hi SpecialKey guifg=#525252 ctermbg=NONE guibg=NONE
hi NonText guifg=#525252 ctermbg=NONE guibg=NONE

" ,j ,k ,l -- close, prev buffer, next buffer
nn <leader>j :bdelete<return>
nn <leader>k :bp<return>
nn <leader>l :bn<return>

" Lx -- close quickfix
nn Lx :ccl<return>

" line numbers & relative number switching
nn <leader>? :set rnu!<return>

" make stargate behave like easymotion
noremap <leader><leader>w <Cmd>call stargate#OKvim('\<')<CR>
noremap <leader><leader>e <Cmd>call stargate#OKvim('\S\>')<CR>
noremap <leader><leader>l <Cmd>call stargate#OKvim('\_^')<CR>
noremap <leader><leader>E <Cmd>call stargate#OKvim('\S\s*$')<CR>
noremap <leader><leader>$ <Cmd>call stargate#OKvim('$')<CR>
noremap <leader><leader>[ <Cmd>call stargate#OKvim('[(){}[\]]')<CR>

inoremap <expr> <c-\>d substitute(system("date +'%x %A'"), '\n\+$', '', '')

call lsp#diag#DiagsHighlightDisable()

nn <silent> Li :LspHover<cr>
nn <silent> Ls :LspServer show status<cr>
nn <silent> L{ :LspGotoTypeDef<cr>
nn <silent> L} :LspGotoImpl<cr>
nn <silent> L] :LspGotoDeclaration<cr>
nn <silent> L[ :LspGotoDefinition<cr>
nn <silent> Lp :LspShowReferences<cr>

if executable('clangd')
  call LspAddServer([{
\   'name': 'clangd',
\   'filetype': ['c', 'cpp'],
\   'path': 'clangd',
\   'args': ['--background-index']
\ }])
endif

if executable('pylsp')
  call LspAddServer([{
\   'name': 'pylsp',
\   'filetype': 'python',
\   'path': 'pylsp',
\   'args': []
\ }])
endif

