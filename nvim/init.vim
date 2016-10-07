function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdtree'
"Plug 'powerman/vim-plugin-ruscmd'
"Plug 'jceb/vim-orgmode'
"Plug 'majutsushi/tagbar'
"Plug 'tpope/vim-speeddating'
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
"Plug 'kshenoy/vim-signature'
"Plug 'Yggdroot/indentLine'
Plug 'flazz/vim-colorschemes'
Plug 'tmhedberg/SimpylFold'
Plug 'chrisbra/csv.vim'
Plug 'terryma/vim-multiple-cursors'
"Plug 'Shougo/neosnippet'
"Plug 'Shougo/neosnippet-snippets'
"Plug 'Raimondi/delimitMate'

"Plug 'fatih/vim-go'
"Plug 'zchee/deoplete-go', { 'do': 'make'}

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 's3rvac/AutoFenc'
" syntax
Plug 'ekalinin/Dockerfile.vim'
call plug#end()

filetype plugin indent on

" Keyboard layout switching settings
"set keymap=russian-jcukenwin
"set iminsert=0
"set imsearch=0
"highlight lCursor guifg=NONE guibg=Cyan

" Common {{{
set termguicolors
set termcap
syntax enable
colorscheme molokai
set background=dark
set number
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40
" }}}

" Keys {{{
let mapleader = ","
" }}}

" XML {{{
let g:xml_syntax_folding=1
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
au FileType xml setlocal foldmethod=syntax
"}}}


" Plugins {{{

" vim-airline {{
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = "powerlineish"
" }}


" nerdtree {{
map <C-T> :NERDTreeToggl<CR>
" }}
