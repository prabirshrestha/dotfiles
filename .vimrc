" curl -Lk https://bit.ly/prabir-vimrc -o ~/.vimrc
" to use existing vim configuration as neovim configuration
" ln -s ~/.vimrc ~/.config/nvim/init.vim
" For windows download lua binaries from https://sourceforge.net/projects/luabinaries/files/5.3.3/Windows%20Libraries/Dynamic/lua-5.3.3_Win64_dll11_lib.zip/download
" Fro mac: brew install vim --HEAD --with-override-system-vi --with-luajit --with-python3 --with-tcl --with-gettext --enable-gui --with-client-server
set nocompatible
set encoding=utf-8
scriptencoding utf-8
set fileformats=unix,mac,dos
set termencoding=utf-8
syntax on
filetype plugin indent on
set backspace=indent,eol,start
set nobackup noswapfile

let mapleader = ' '
nnoremap ; :

" vimrc {{{
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}

let s:settings = {
    \ 'data_dir': expand('~/.config/nvim/data'),
    \ 'plugins_dir': expand('~/.config/nvim/plugins'),
    \ 'vim_plug_script_path': expand('~/.config/nvim/plug.vim'),
    \ 'auto_install_plugins': 0,
    \ }
let s:settings['vim_plug_script_path'] = expand('~/.config/nvim/plug.vim')
let s:settings['plugins_dir'] = expand('~/.config/nvim/plugins')

if !filereadable(s:settings['vim_plug_script_path'])
  if !executable('curl') | echom 'curl required to download vim-plug' | endif
  if has('win32') && &shellslash
    let s:settings['vim_plug_script_path'] = substitute(s:settings['vim_plug_script_path'], '/', '\\', 'g')
  endif
  execute 'silent !curl -fkLo "' . s:settings['vim_plug_script_path'] . '" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  let s:settings['auto_install_plugins'] = 1
endif
execute 'source ' . s:settings['vim_plug_script_path']

call plug#begin(s:settings['plugins_dir'])
  Plug 'iCyMind/NeoSolarized'
  Plug 'lifepillar/vim-solarized8'
  Plug 'luochen1990/rainbow'

  Plug 'thinca/vim-themis', { 'on': [] }
  Plug 'sheerun/vim-polyglot'
  Plug 'DataWraith/auto_mkdir'
  Plug 'Lokaltog/vim-easymotion', { 'on': ['<Plug>(easymotion-s)'] }
  Plug 'airblade/vim-rooter'

  Plug 'cohama/lexima.vim'
  Plug 'justinmk/vim-gtfo'
  Plug 'lambdalisue/gina.vim'
  Plug 'cohama/agit.vim', { 'on': ['Agit', 'AgitFile'] }
  Plug 'mattn/emmet-vim'
  Plug 'sgur/vim-editorconfig'
  Plug 'tpope/vim-commentary'
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeFind', 'NERDTreeToggle'] }
  Plug 'diepm/vim-rest-console'
  Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

  Plug 'prabirshrestha/callbag.vim'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'mattn/vim-lsp-icons'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete-file.vim'
  Plug 'yami-beta/asyncomplete-omni.vim'
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  Plug 'Shougo/neco-syntax' | Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
  Plug 'Shougo/neco-vim' | Plug 'prabirshrestha/asyncomplete-necovim.vim'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'prabirshrestha/vsnip-snippets'

  Plug 'prabirshrestha/quickpick.vim'
  Plug 'prabirshrestha/quickpick-colorschemes.vim'
  Plug 'prabirshrestha/quickpick-filetypes.vim'
  Plug 'prabirshrestha/quickpick-npm.vim'

  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'dbeecham/ctrlp-commandpalette.vim', { 'on': ['CtrlPCommandPalette'] }
  Plug 'okcompute/vim-ctrlp-session'
  if has('python') || has('python3') | Plug 'FelikZ/ctrlp-py-matcher' | endif

  Plug 'mattn/vim-fz'

  Plug 'm-pilia/vim-yggdrasil'
  Plug 'mhinz/vim-lookup', { 'for': 'vim' }
  Plug 'tpope/vim-markdown'

  Plug 'markonm/traces.vim'
  Plug 'troydm/zoomwintab.vim'
  Plug 'prabirshrestha/split-term.vim', { 'branch': 'vim8', 'on': ['Term', 'VTerm', 'TTerm'] }

  if has('nvim') | Plug 'equalsraf/neovim-gui-shim' | endif
call plug#end()

if s:settings['auto_install_plugins']
  autocmd VimEnter * PlugClean! | PlugUpdate --sync
endif

" ui
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)
if has('termguicolors') | set termguicolors | endif
set background=dark
silent! colorscheme solarized8
if has('directx') | set renderoptions=type:directx | endif
if has('gui_running') | set guioptions=Mc! | endif

if exists('g:neovide')
  set guifont=Fira\ Code\ Retina:h18
else
  set guifont=Fira\ Code\ Retina:h12
endif

set mouse=a                         " automatically enable mouse usage
set noerrorbells visualbell t_vb=   " no annoying sound on errors
set shortmess+=OI
set nu                              " set line numbers on
set completeopt+=noinsert,noselect
set completeopt-=popup
set wildmenu                        " show list instead of just completing
set nowrap                          " Do not wrap long lines
set autoindent                      " Indent at the same level of the previous line
set shiftwidth=4                    " Use indents of 4 spaces
set expandtab                       " Tabs are spaces, not tabs
set tabstop=4                       " An indentation every four columns
set softtabstop=4                   " Let backspace delete indent
set nojoinspaces                    " Prevents inserting two spaces after punctuation on a join (J)
set splitright                      " Puts new vertical split windows to the right of the current
set splitbelow                      " Puts new split windows to the bottom of the current
set pastetoggle=<F12>               " paste toggle (sane indentation pastes)
set signcolumn=no                  " always disable signcoumn
set cmdheight=2

" Move up and down in autocomplete with <c-j> and <c-k>
inoremap <expr> <C-j> ("\<C-n>")
inoremap <expr> <C-k> ("\<C-p>")

" Highlight problematic whitespace
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set showbreak=···

set incsearch                       " find as you type
set hlsearch                        " highlight search terms
set ignorecase                      " case in-sensitive search
set smartcase                       " case sensitive when upper case present
" Clear current search highlighting by fast //
nmap <silent> // :nohlsearch<CR>

set clipboard+=unnamedplus           " always use system clipboard

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>
nnoremap <c-s> :w<CR>
inoremap <c-s> <esc>:w<CR>i

nnoremap <silent> <leader>t2     :setl shiftwidth=2 softtabstop=2<CR>
nnoremap <silent> <leader>t4     :setl shiftwidth=4 softtabstop=4<CR>
nnoremap <silent> <leader>t8     :setl shiftwidth=8 softtabstop=8<CR>

" Insert mode:
inoremap <M-h> <Esc><c-w>h
inoremap <M-j> <Esc><c-w>j
inoremap <M-k> <Esc><c-w>k
inoremap <M-l> <Esc><c-w>l
" Visual mode:
vnoremap <M-h> <Esc><c-w>h
vnoremap <M-j> <Esc><c-w>j
vnoremap <M-k> <Esc><c-w>k
vnoremap <M-l> <Esc><c-w>l
" Normal mode:
nnoremap <M-h> <c-w>h
nnoremap <M-j> <c-w>j
nnoremap <M-k> <c-w>k
nnoremap <M-l> <c-w>l

" vim-grepper {{{
nnoremap <Leader>s :Grepper -cword -highlight<CR>
" }}}

" vim-easymotion {{{
let g:EasyMotion_keys='hklyuiopnm,qwertzxcvbasdgjf'
nmap s <Plug>(easymotion-s)
" }}}

" gina.vim {{{
if has_key(g:plugs, 'gina.vim')
  let g:gina#command#blame#formatter#format = "%in %au %=on %ti"
  nnoremap <leader>gb :Gina blame :<CR>
  nnoremap <leader>gbr :Gina branch<CR>
  nnoremap <leader>gd :Gina diff<CR>
  nnoremap <leader>gl :Gina log<CR>
  nnoremap <leader>gs :Gina status<CR>
  nnoremap <leader>gc :Gina commit<CR>
  let s:gina_cmd_opt = {'noremap': 1, 'silent': 1}
  call gina#custom#mapping#nmap('blame', 'dd', '<Plug>(gina-diff-tab)')
  call gina#custom#mapping#nmap('blame', 'ee', '<Plug>(gina-blame-echo)')
  call gina#custom#mapping#nmap('log', 'dd', '<Plug>(gina-diff-tab)')
  call gina#custom#mapping#nmap('status', '<C-]>', ':<C-U>Gina commit<CR>', s:gina_cmd_opt)
  call gina#custom#mapping#nmap('/.*', 'q', ':<C-U>bd<CR>', s:gina_cmd_opt)
  call gina#custom#mapping#nmap('/.*', '<C-t>', '<Plug>(gina-edit-tab)')
endif
" }}}

" ctrlp.vim and vim-fz {{{
let g:ctrlp_cache_dir = expand(s:settings['data_dir'] . '/ctrlp')
let g:ctrlp_session_path = expand(s:settings['data_dir'] . './ctrlp-sessions')
let g:ctrlp_clear_cache_on_exit = 0
if has('python') || has('python3')
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

if executable('gof')
  nmap ,f <Plug>(fz)
  let g:ctrlp_map = ''
  nnoremap <C-p> :call fz#run({ 'type': 'cmd', 'cmd': 'git ls-files' })<CR>
endif

nnoremap <leader>r :CtrlPMRUFiles<CR>
nnoremap <leader>qf :cclose <CR>:CtrlPQuickfix<CR>
" }}}

" asyncomplete.vim and vim-lsp {{{
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand(s:settings['data_dir'] . '/lsp.log')
" let g:asyncomplete_log_file = expand(s:settings['data_dir'] . '/asyncomplete.log')
let g:lsp_virtual_text_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1
let g:vsnip_snippet_dir = expand(s:settings['plugins_dir'] . '/vsnip-snippets/vsnips')

let g:asyncomplete_auto_popup = 1
" terminal vim treats c-@ as c-space, neovim doesn't understand c-@ so register both
if !has('nvim') && !has('gui')
  imap <c-@> <Plug>(asyncomplete_force_refresh)
else
  imap <c-space> <Plug>(asyncomplete_force_refresh)
endif
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

imap <expr> <Tab> pumvisible() ? "\<c-n>" : vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : "\<Tab>"
smap <expr> <Tab> pumvisible() ? "\<c-n>" : vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : "\<Tab>"
imap <expr> <S-Tab> pumvisible() ? "\<c-p>" : vsnip#available(1) ? '<Plug>(vsnip-jump-prev)' : "\<S-Tab>"
smap <expr> <S-Tab> pumvisible() ? "\<c-p>" : vsnip#available(1) ? '<Plug>(vsnip-jump-prev)' : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<CR>"
inoremap <expr> <C-y> pumvisible() ? asyncomplete#close_popup() : "\<C-y>"
inoremap <expr> <C-e> pumvisible() ? asyncomplete#cancel_popup() : "\<C-e>"

autocmd! FileType rust setlocal tabstop=4 softtabstop=4

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gD <plug>(lsp-references)
  nnoremap <buffer> gs :<C-u>LspDocumentSymbol<CR>
  nnoremap <buffer> gS :<C-u>LspWorkspaceSymbol<CR>
  nnoremap <buffer> gQ :<C-u>LspDocumentFormat<CR>
  vnoremap <buffer> gQ :LspDocumentRangeFormat<CR>
  nnoremap <buffer> K :<C-u>LspHover<CR>
  nnoremap <buffer> <F1> :<C-u>LspImplementation<CR>
  nnoremap <buffer> <F2> :<C-u>LspRename<CR>
  nnoremap <buffer> <leader>ca :LspCodeAction<CR>
  xnoremap <buffer> <leader>ca :LspCodeAction<CR>
  autocmd! BufWritePre *.rs call execute('LspDocumentFormatSync')
endfunction

augroup configure_lsp
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }}}

" vim-lookup {{{
autocmd FileType vim nnoremap <buffer><silent> <c-]>  :call lookup#lookup()<cr>
autocmd FileType vim nnoremap <buffer><silent> <c-t>  :call lookup#pop()<cr>
" }}}

" vim-gtfo {{{
if has('win32') | let g:gtfo#terminals = { 'win' : 'cmd /k' } | endif
"}}}

" vim-closetag {{{
" https://github.com/alvan/vim-closetag/issues/1
let g:closetag_filenames = "*.xml,*.html,*.html,*.tsx,*.config"
au FileType xml,html,xhtml,js,typescript let b:delimitMate_matchpairs = "(:),[:],{:}"
" }}}

" nerdtree {{{
nnoremap <silent> <leader>e :NERDTreeFind<CR>
nnoremap <silent> <leader>E :NERDTreeToggle<CR>
" }}}

" ctrlp-commandpalette.vim {{{
nnoremap <leader>p :CtrlPCommandPalette<cr>
let g:ctrlp_commandpalette_autoload_commands = 0
let g:commandPalette = {
    \ 'Change filetype': 'Pfiletypes',
    \ 'Change Colorscheme': 'Pcolorscheme',
    \ 'LSP: goto definition': 'LspDefinition',
    \ 'GUI Font picker': 'set guifont=*',
    \ 'Current font name': 'set guifont?',
    \ 'GitFiles': 'GitFiles',
    \ 'Ignorecase: Toggle': 'set ignorecase!',
    \ 'Sessions': 'CtrlPSession',
    \ }
" }}}

if filereadable(expand('~/.vimrc.local')) | source ~/.vimrc.local | endif

" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{{,}}} foldmethod=marker spell:
