" curl -Lk https://bit.ly/prabir-vimrc -o ~/.vimrc
" to use existing vim configuration as neovim configuration
" ln -s ~/.vimrc ~/.config/nvim/init.vim
" For windows download lua binaries from https://sourceforge.net/projects/luabinaries/files/5.3.3/Windows%20Libraries/Dynamic/lua-5.3.3_Win64_dll11_lib.zip/download
set nocompatible
set encoding=utf-8
scriptencoding utf-8
set fileformats=unix,mac,dos
set termencoding=utf-8
syntax on
filetype plugin indent on
set backspace=indent,eol,start
set nobackup noswapfile
let mapleader = "\<Space>"

let s:settings_config_dir = expand('~/.config/nvim')
let s:settings_plug_path = expand(s:settings_config_dir . '/plug.vim')
let s:settings_plugin_dir = expand(s:settings_config_dir . '/plugins')
let s:settings_data_dir = expand(s:settings_config_dir . '/data')

if !filereadable(s:settings_plug_path)
  silent! exec 'silent !curl -fkLo "' . s:settings_plug_path . '" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endi
silent! exec 'source ' . s:settings_plug_path

let g:plug_shallow = 0
call plug#begin(s:settings_plugin_dir)
  Plug 'lifepillar/vim-solarized8'

  Plug 'itchyny/lightline.vim'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'justinmk/vim-gtfo'
  Plug 'andymass/vim-matchup'
  Plug 'airblade/vim-rooter'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'DataWraith/auto_mkdir'
  Plug 'Lokaltog/vim-easymotion', { 'on': ['<Plug>(easymotion-s)'] }
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/gina.vim'
  Plug 'tpope/vim-commentary'
  Plug 'dominickng/fzf-session.vim'

  Plug 'thinca/vim-themis'
  Plug 'cohama/lexima.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'lambdalisue/vim-backslash', { 'filetype': 'vim' }
  Plug 'lambdalisue/vim-findent'
  Plug 'tweekmonster/helpful.vim'
  Plug 'cespare/vim-toml'
  Plug 'stephpy/vim-yaml'
  Plug 'rust-lang/rust.vim'
  Plug 'plasticboy/vim-markdown'

  Plug 'prabirshrestha/callbag.vim'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'mattn/vim-lsp-icons'
  Plug 'prabirshrestha/asyncomplete.vim'
	Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'prabirshrestha/vsnip-snippets'
call plug#end()

if has('gui_running')
  set guioptions=Mc!
  silent! set guifont=FiraCode\ 12
endif

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

if !has('gui_running') | set t_Co=256 | endif
set termguicolors
set background=dark
silent! colorscheme solarized8
let g:lightline = { 'colorscheme': 'solarized' }

set mouse=a                           " automatically enable mouse usage
set noerrorbells visualbell t_vb=     " no annoying sound on errors
set shortmess+=OI
set nu                                " set line numbers on
set updatetime=300
set cmdheight=2
set autoindent
set timeoutlen=300 " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set scrolloff=2
set noshowmode
set hidden
set nowrap

set pastetoggle=<F12>               " paste toggle (sane indentation pastes)
" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

set nojoinspaces
set signcolumn=no
set printfont=:h10
set printencoding=utf-8
set printoptions=paper:letter
set splitright
set splitbelow

exec 'set undodir=' . expand(s:settings_data_dir) . '/undo'
set undofile

set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor

set shiftwidth=4                    " Use indents of 4 spaces
set expandtab                       " Tabs are spaces, not tabs
set tabstop=4                       " An indentation every four columns
set softtabstop=4                   " Let backspace delete indent
nnoremap <silent> <leader>t2     :setl shiftwidth=2 softtabstop=2<CR>
nnoremap <silent> <leader>t4     :setl shiftwidth=4 softtabstop=4<CR>
nnoremap <silent> <leader>t8     :setl shiftwidth=8 softtabstop=8<CR>

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault
" Clear current search highlighting by fast //
nmap <silent> // :nohlsearch<CR>

set nofoldenable

set ttyfast
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw
set synmaxcol=500
set laststatus=2
set relativenumber " Relative line numbers

set number " Also show current absolute line
set diffopt+=iwhite " No whitespace in vimdiff

set diffopt+=algorithm:patience
set diffopt+=indent-heuristic
set colorcolumn=80 " and give me a colored column
set showcmd " Show (partial) command in status line.

" Show those damn hidden characters
" Verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" Quick save
nmap <leader>w :w<CR>

" vimrc {{{
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" Keyboard shortcuts
nnoremap ; :

" Ctrl+c and Ctrl+j as Esc
" Ctrl-j is a little awkward unfortunately:
" https://github.com/neovim/neovim/issues/5916
" So we also map Ctrl+k
inoremap <C-j> <Esc>

nnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
cnoremap <C-k> <Esc>
onoremap <C-k> <Esc>
lnoremap <C-k> <Esc>
tnoremap <C-k> <Esc>

nnoremap <C-c> <Esc>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>
snoremap <C-c> <Esc>
xnoremap <C-c> <Esc>
cnoremap <C-c> <Esc>
onoremap <C-c> <Esc>
lnoremap <C-c> <Esc>
tnoremap <C-c> <Esc>

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

map <C-p> :Files<CR>

let g:fzf_session_path = expand(s:settings_data_dir, '/fzfsession')

" <leader>s for Rg search
noremap <leader>s :Rg
let g:fzf_layout = { 'down': '~40%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

let g:sneak#s_next = 1

" Prevent accidental writes to buffers that shouldn't be edited
autocmd BufRead *.orig set readonly

" Jump to last edit position on opening file
if has("autocmd")
  " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" asyncomplete.vim,vim-lsp,vsnip {{{
let g:vsnip_snippet_dir = expand(s:settings_plugin_dir . '/vsnip-snippets/vsnips')

imap <expr> <Tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : pumvisible() ? "\<C-n>" : "\<Tab>"
smap <expr> <Tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : pumvisible() ? "\<C-n>" : "\<Tab>"
imap <expr> <S-Tab> vsnip#available(1) ? '<Plug>(vsnip-jump-prev)' : pumvisible() ? "\<C-p>" : "\<S-Tab>"
smap <expr> <S-Tab> vsnip#available(1) ? '<Plug>(vsnip-jump-prev)' : pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<CR>"
inoremap <expr> <C-y> pumvisible() ? asyncomplete#close_popup() : "\<C-y>"
inoremap <expr> <C-e> pumvisible() ? asyncomplete#cancel_popup() : "\<C-e>"

" Move up and down in autocomplete with <c-j> and <c-k>
inoremap <expr> <C-j> ("\<C-n>")
inoremap <expr> <C-k> ("\<C-p>")

autocmd! CompleteDone * if !pumvisible() | pclose | endif

au! FileType rust setlocal tabstop=4 softtabstop=4 colorcolumn=100

" Use K to show documentation in preview window or popup window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    execute "normal \<plug>(lsp-hover)"
  endif
endfunction

"let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand(s:settings_data_dir . '/lsp.log')
"let g:asyncomplete_log_file = expand(s:settings_data_dir. '/asyncomplete.log')
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <silent> [g <Plug>(lsp-previous-diagnostic)
  nmap <silent> ]g <Plug>(lsp-next-diagnostic)
  "nmap <buffer> K <plug>(lsp-hover)

  nnoremap <buffer> gs :<C-u>LspDocumentSymbol<CR>
  nnoremap <buffer> gS :<C-u>LspWorkspaceSymbol<CR>
  nnoremap <buffer> gQ :<C-u>LspDocumentFormat<CR>
  vnoremap <buffer> gQ :LspDocumentRangeFormat<CR>
  nnoremap <buffer> <leader>ca :LspCodeAction<CR>
  xnoremap <buffer> <leader>ca :LspCodeAction<CR>
  autocmd! BufWritePre *.rs call execute('LspDocumentFormatSync')
endfunction

augroup configure_lsp
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }}}

" vim-gtfo {{{
if has('win32') | let g:gtfo#terminals = { 'win' : 'cmd /k' } | endif
"}}}

" vim-easymotion {{{
let g:EasyMotion_keys='hklyuiopnm,qwertzxcvbasdgjf'
nmap s <Plug>(easymotion-s)
" }}}

if filereadable(expand('~/.vimrc.local')) | source ~/.vimrc.local | endif

" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{{,}}} foldmethod=marker spell:
