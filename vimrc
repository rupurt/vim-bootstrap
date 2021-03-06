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
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
map <silent> <leader>f :FZF<CR>
map <leader>b :Buffers<CR>
let g:fzf_layout = { 'down': '~30%' }

" Vertical selection
Plug 'terryma/vim-multiple-cursors'

" Lazy loaded language packs
Plug 'sheerun/vim-polyglot'

" Use LSP's within neovim/vim8
let g:coc_global_extensions = [
\ 'coc-ultisnips',
\ 'coc-json',
\ 'coc-tsserver',
\ 'coc-html',
\ 'coc-css',
\ 'coc-go',
\ 'coc-yaml',
\ 'coc-json',
\ 'coc-eslint',
\ 'coc-elixir'
\ ]
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Code Navigation
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gt <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Applying codeAction to the selected region.
nmap <leader>ca  <Plug>(coc-codeaction-selected)

" Apply AutoFix to problem on the current line.
nmap <leader>cf  <Plug>(coc-fix-current)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" Remap for refactor current word
nmap <leader>rf <Plug>(coc-refactor)
" Format selected code
vmap F <Plug>(coc-format-selected)

" Specific LS commands
" Generate unit tests for file
autocmd FileType go nmap gf :CocCommand go.test.generate.file<cr>
" Generate unit tests for file
autocmd FileType go nmap ge :CocCommand go.test.generate.exported<cr>

" Fast & minimal powerline
Plug 'itchyny/lightline.vim'
let g:lightline = {}

" Display CoC indicators in lightline
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction'
      \ },
      \ }

" Pastel color schemes with sensible highlighting
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

" Quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" Remaps . in a way that plugins can tap into
Plug 'tpope/vim-repeat'

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
