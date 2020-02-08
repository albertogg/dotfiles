call plug#begin('~/.vim/plugged')

" Plugins
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rbenv', { 'for': 'ruby' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Shougo/neocomplete'
Plug 'fatih/vim-go'
Plug 'b4b4r07/vim-hcl'  " syntax highlighting
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'janko-m/vim-test',
Plug 'junegunn/vim-easy-align'
Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}

" Add plugins to &runtimepath
call plug#end()

"----------------
" general
"----------------
scriptencoding utf-8
set encoding=utf-8
set nocompatible               " no compatible
set t_Co=256                   " Use 256 colors
set backspace=indent,eol,start " fix the backspace in vim
set nobackup
set nowritebackup
set noswapfile                 " Don't write swp file
set autowrite                  " Automatically :write before running commands

" set clipboard to unnamed so we have proper clipboard copy for vim we need to
" install hombrew vim for it to work
set clipboard=unnamed

"----------------
" Text Formating
"----------------
syntax on
set autoindent
set tabstop=2        " Number of visual spaces per TAB
set softtabstop=2    " Number of spaces in tab when editing
set shiftwidth=2     " Number of spaces per indentation movement
set expandtab        " Use an amount of spaces to expand a tab
set nosmarttab
set wrap
set linebreak
set textwidth=0      " Ensure that long lines will not be broken when pasting
set complete+=kspell " Autocomplete with dictionary words when spell check is on

"----------------
" Autocomplete
"----------------
filetype plugin on
set omnifunc=syntaxcomplete#Complete

"----------------
" GUI
"----------------
if has("gui_running")
  set go-=L             " Remove left scrollbar
  set go-=r             " Remove right scrollbar
endif

"----------------
" UI
"----------------
" paint colorcolumn with a custom color
highlight ColorColumn guibg=#32322f ctermbg=236
silent! colorscheme onedark        " Use molokai colorscheme
set colorcolumn=80,100             " Delimiter line at 80 and 100 characters
set laststatus=2                   " Always show the status line!
set ruler                          " Show the cursor position all the time
set number                         " Show line numbers
set numberwidth=5                  " Numbers 5 character width
set showcmd                        " Show command in bottom bar
set list                           " Show list of characters
set listchars=tab:»·,eol:¬,trail:· " Invisible characters notations
set diffopt+=vertical              " Always use vertical diffs
set history=50                     " Lines of history
set ignorecase                     " Search case insensitive
set incsearch                      " Show matches while typing
set hlsearch                       " Highlight search results
set showmatch                      " Show matching brackets flickering
set completeopt-=preview           " Don't pop-up completions code previews
set splitbelow                     " Open new split panes at the bottom
set splitright                     " Open new split panes to right
set wildmenu                       " Visual autocomplete for command menu
set lazyredraw                     " Redraw only when we need to.

"----------------
" Mappings
"----------------
let mapleader = ','

" Escape insert mode with jj
inoremap jj <Esc>

" Move through splits with ctrl + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Call StripTrailingWhitespaces
nnoremap <leader><space> :call StripTrailingWhitespaces()<CR>

" Clear highlighted search text
nnoremap <silent> <Esc><Esc> :let @/=""<CR>

" Shift + return to add end to ruby functions.
imap <S-CR> <CR><CR>end<Esc>-cc
imap ,. <C-X><C-O>

" Reload .vimrc config
nnoremap <silent> <leader>V :so ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

"----------------
" rails.vim
"----------------
inoremap <C-Space> <C-x><C-u>

"----------------
" GitGutter
"----------------
nnoremap <leader>g :GitGutterToggle<CR>

"----------------
" EasyAlign
"----------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"----------------
" CtrlP
"----------------
nnoremap <leader>. :CtrlP<CR>
nnoremap <leader>t :CtrlPTag<CR>

set wildignore+=*/node_modules/*,*/vendor/*

let g:ctrlp_map = '<leader>b'
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_use_caching = 1
let g:ctrlp_show_hidden = 1

if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --hidden --color=never --glob "!.git/*"'
  let g:ctrlp_use_caching = 0
endif

"----------------
" lightline.vim
"----------------
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

"----------------
" neocomplete
"----------------
" Use neocomplete
let g:neocomplete#enable_at_startup = 1
" Use smartcase
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length
let g:neocomplete#sources#syntax#min_keyword_length = 3

"----------------
" vim-test
"----------------
nnoremap <silent> <Leader>T :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <leader>gt :TestVisit<CR>

"----------------
" autogroups
"----------------
augroup vimrcEx
  autocmd!
  " strip trailing whitespace on Ruby buffer saves
  autocmd BufWritePre *.rb,*.sh,*.md,*.html,*.css,*.scss,*.js,*.java call StripTrailingWhitespaces()
  " set filetype, textwidth and spell checking to markdown files
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.md,*.markdown setlocal textwidth=80
  autocmd BufRead,BufNewFile *.md,*.markdown setlocal spell
  " set spell in gitcommits
  autocmd FileType gitcommit setlocal spell
  " Go, Java, XML and Make files configuration
  autocmd FileType go,java,xml,make setl expandtab softtabstop=4 tabstop=4 shiftwidth=4
  " vim-go plugin
  autocmd FileType go let g:go_fmt_command = "goimports"
  autocmd FileType go let g:go_highlight_functions = 1
  autocmd FileType go let g:go_highlight_methods = 1
  autocmd FileType go let g:go_highlight_fields = 1
  autocmd FileType go let g:go_highlight_types = 1
  autocmd FileType go let g:go_highlight_operators = 1
  autocmd FileType go let g:go_highlight_build_constraints = 1
  autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
  autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
  autocmd FileType go nmap <Leader>r <Plug>(go-run)
  autocmd FileType go nmap <Leader>B <Plug>(go-build)
  autocmd FileType go nmap <Leader>T <Plug>(go-test)
  autocmd FileType go nmap <leader>c <Plug>(go-coverage)
  autocmd FileType go nmap <Leader>e <Plug>(go-rename)
  autocmd FileType go nmap <Leader>s <Plug>(go-implements)
  " Ruby and Rails autocomplete functionality
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
augroup END

"----------------
" functions
"----------------
function! StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let previous_search=@/
    let previous_cursor_line = line(".")
    let previous_cursor_column = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=previous_search
    call cursor(previous_cursor_line, previous_cursor_column)
endfunction
