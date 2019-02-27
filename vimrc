set nocompatible
filetype on
filetype off

" Share vimrc initialization between vim & nvim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Yank to system clipboard
set clipboard=unnamed

let mapleader = ','

let s:shared_config = expand($HOME . '/.vimrc.shared')
if filereadable(s:shared_config)
  exec ':source ' . s:shared_config
endif

let s:local_config = expand($HOME . '/.vimrc.local')
if filereadable(s:local_config)
  exec ':source ' . s:local_config
endif

"
" Plugins
"
"""""""""""""""""""""""""""""""""""""""
set rtp+=~/.vim/autoload/plug.vim
call plug#begin('~/.vim/plugged')

let s:shared_bundles = expand($HOME . '/.vimrc.bundles.shared')
if filereadable(s:shared_bundles)
  silent! exec ':source ' . s:shared_bundles
endif

let s:local_bundles = expand($HOME . '/.vimrc.bundles.local')
if filereadable(s:local_bundles)
  silent! exec ':source ' . s:local_bundles
endif

" Command line fuzzy finder
" Much faster than ctrlp, especially on large screens
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
map <silent> <leader>f :FZF<CR>
map <leader>b :Buffers<CR>
let g:fzf_layout = { 'down': '~30%' }

" Vertical selection
Plug 'terryma/vim-multiple-cursors'

" Lazy loaded language packs
Plug 'sheerun/vim-polyglot'

" Async linting/fixing engine
Plug 'w0rp/ale'
let g:ale_linters = {
  \ 'elixir': ['elixir-ls', 'mix'],
  \ 'typescript': ['tslint'],
  \ 'javascript': ['prettier'],
  \ 'css': ['prettier']
  \ }
let g:ale_fixers = {
  \ 'elixir': ['mix_format'],
  \ 'typescript': ['tslint'],
  \ 'javascript':  ['prettier'],
  \ 'css': ['prettier']
  \ }
let g:ale_elixir_elixir_ls_release = expand($HOME . '/workspace/elixir-ls/rel')
let g:ale_fix_on_save = 1
nmap <leader>d <Plug>(ale_go_to_definition)

" Async intellisense
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

" Fast & minimal powerline
Plug 'itchyny/lightline.vim'

" Display ale indicators in lightline
Plug 'maximbaz/lightline-ale'
let g:lightline = {}
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }
let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }

" Pastel color schemes with sensible highlighting
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

" Quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" Comment stuff out
Plug 'tpope/vim-commentary'
xmap <leader>/ <Plug>Commentary
nmap <leader>/ <Plug>CommentaryLine

" ctags
map <leader>rt :!ctags --extras=+f --exclude=.git --exclude=log --exclude=doc -R *<CR><CR>
map <C-\> :tnext<CR>

call plug#end()

"
" Color
"
"""""""""""""""""""""""""""""""""""""""
colorscheme Tomorrow-Night-Eighties

"
" Options
"
"""""""""""""""""""""""""""""""""""""""

set notimeout      " no command timeout
set expandtab      " use soft tabs
set tabstop=2
set shiftwidth=2   " width of auto-indent
set softtabstop=2
set nowrap         " no wrapping
set textwidth=0
set number         " line numbers
set numberwidth=4

" completion sources: (current file, loaded buffers, unloaded buffers, tags)
set complete=.,b,u,]

set wildmode=longest,list:longest
set wildignore+=*vim/backups*
set wildignore+=*DS_Store*
set wildignore+=tags
set wildignore+=*/tmp/**
set wildignore+=*/log/**
set wildignore+=.git,*.rbc,*.class,.svn,*.png,*.jpg,*.gif

set list           " show whitespace
if has('gui_running')
  set listchars=trail:·
else
  set listchars=trail:~
endif

set showtabline=2  " always show tab bar
set showmatch      " show matching brackets
set hidden         " allow hidden, unsaved buffers
set splitbelow     " add new window towards right
set splitright     " add new window towards bottom
set scrolloff=3    " scroll when the cursor is 3 lines from bottom
set sidescroll=1
set sidescrolloff=5
set cursorline     " highlight current line

" Turn folding off for real, hopefully
set foldmethod=manual
set nofoldenable

" make searches case-sensitive only if they contain upper-case characters
set smartcase

" store temporary files in a central spot
set backupdir=~/.vim-tmp//,~/.tmp//,~/tmp//,/var/tmp//,/tmp//
set directory=~/.vim-tmp//,~/.tmp//,~/tmp//,/var/tmp//,/tmp//

" switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has('gui_running')
  set hlsearch
endif

" keep undo history across sessions, by storing in file.
if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups//
  set undofile
endif

"
" Formatting
"
"""""""""""""""""""""""""""""""""""""""

" strip trailing whitespace on save
function! StripTrailingWhitespace()
  let save_cursor = getpos('.')
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction
autocmd BufWritePre *.rb,*.yml,*.js,*jsx,*.css,*.less,*.sass,*.scss,*.html,*.xml,*.erb,*.coffee call StripTrailingWhitespace()

"
" Keybindings
"
"""""""""""""""""""""""""""""""""""""""

nmap \ :Explore<CR>

" clear the search buffer when hitting space
:nnoremap <space> :nohlsearch<cr>

" sometimes I hold the shift too long ... just allow it
cabbrev W w
cabbrev Q q
cabbrev Tabe tabe

" split screen
:noremap <leader>v :vsp<CR>
:noremap <leader>h :split<CR>

" toggle fullscreen
:noremap tt :tab split<CR>
:noremap ty :tabc <CR>

" opens an edit command with the path of the currently edited file filled in
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" opens a tab edit command with the path of the currently edited file filled in
" map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" make Y consistent with D and C
map Y y$
map <silent> <leader>y :<C-u>silent '<,'>w !pbcopy<CR>

" copy current file path to system pasteboard
map <silent> <D-C> :let @* = expand("%")<CR>:echo "Copied: ".expand("%")<CR>
map <leader>C :let @* = expand("%").":".line(".")<CR>:echo "Copied: ".expand("%").":".line(".")<CR>

" indent/unindent visual mode selection with tab/shift+tab
vmap <tab> >gv
vmap <s-tab> <gv

" reload .vimrc
map <leader>rv :source ~/.vimrc<CR>

" open next/previous quickfix row
map <M-D-Down>  :cn<CR>
map <M-D-Up>    :cp<CR>

" open/close quickfix window
map <leader>qo  :copen<CR>
map <leader>qc  :cclose<CR>

" insert SecureRandom.uuid at current cursor
function! RandomUuid()
  let command = "uuidgen | tr '[:upper:]' '[:lower:]'"
  let result = substitute(system(command), '[\]\|[[:cntrl:]]', '', 'g')
  exec 'norm i' '"' . result . '"'
endfunction

nmap Sz :call RandomUuid()<CR>

if has('gui_macvim')
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert
  map <D-CR> :set invfu<cr>
endif

let s:shared_config = expand($HOME . '/.vimrc.shared.after')
if filereadable(s:shared_config)
  exec ':source ' . s:shared_config
endif

let s:local_config = expand($HOME . '/.vimrc.local.after')
if filereadable(s:local_config)
  exec ':source ' . s:local_config
endif
