call plug#begin('~/.vim/plugged')

" Plugins
Plug 'tpope/vim-vinegar' " Better project drawer
Plug 'tpope/vim-fugitive' " Plugin for Git
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rbenv'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim' " Colorscheme
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'fatih/vim-go'
Plug 'b4b4r07/vim-hcl' " syntax highlighting
Plug 'vim-ruby/vim-ruby'
Plug 'janko-m/vim-test',
Plug 'junegunn/vim-easy-align'
Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

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
set diffopt=vertical               " Always use vertical diffs
set history=50                     " Lines of history
set ignorecase                     " Search case insensitive
set incsearch                      " Show matches while typing
set hlsearch                       " Highlight search results
set showmatch                      " Show matching brackets flickering
set completeopt=longest,menuone    " Don't select the first item but the longest
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

" Some useful quickfix shortcuts for quickfix
map <C-n> :cn<CR>
map <C-m> :cp<CR>
nnoremap <leader>a :cclose<CR>

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
" FileType detect
"----------------
augroup ftdetect
  autocmd!
  " strip trailing whitespace on Ruby buffer saves
  autocmd BufWritePre *.rb,*.sh,*.md,*.html,*.css,*.scss,*.js,*.java call StripTrailingWhitespaces()
  " set filetype, textwidth and spell checking to markdown files
  autocmd BufNewFile,BufRead *.md setl filetype=markdown
  autocmd BufNewFile,BufRead *.md setl expandtab softtabstop=4 shiftwidth=4 tabstop=4
  autocmd BufNewFile,BufRead *.md,*.markdown setl textwidth=80
  autocmd BufNewFile,BufRead *.md,*.markdown setl spell

  autocmd BufNewFile,BufRead *.hcl setl filetype=conf
  autocmd BufNewFile,BufRead *.hcl setl expandtab softtabstop=2 shiftwidth=2 tabstop=2

  autocmd BufNewFile,BufRead *.gotmpl setl filetype=gotexttmpl
  autocmd BufNewFile,BufRead *.html setl expandtab softtabstop=2 shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.sh setl expandtab softtabstop=2 shiftwidth=2 tabstop=2

  autocmd FileType gitcommit setl spell
  autocmd FileType go setl noexpandtab softtabstop=4 shiftwidth=4 tabstop=4
  autocmd FileType yaml setl expandtab softtabstop=2 shiftwidth=2 tabstop=2
  autocmd FileType json setl expandtab softtabstop=2 shiftwidth=2 tabstop=2
  autocmd FileType ruby setl expandtab softtabstop=2 shiftwidth=2 tabstop=2
  autocmd FileType java setl expandtab softtabstop=4 tabstop=4 shiftwidth=4
  autocmd FileType make setl noexpandtab softtabstop=4 tabstop=4 shiftwidth=4
  autocmd FileType xml setl expandtab softtabstop=4 tabstop=4 shiftwidth=4
augroup END

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
" vim-test
"----------------
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <leader>gt :TestVisit<CR>

"----------------
" vim-go
"----------------
let g:go_fmt_command = 'goimports'
let g:go_list_type = 'quickfix'
let g:go_rename_command = 'gopls'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_metalinter_enabled = ['vet', 'golint']

augroup go
  autocmd!

  autocmd FileType go nmap <silent> <Leader>s <Plug>(go-def-split)
  autocmd FileType go nmap <silent> <Leader>v <Plug>(go-def-vertical)
  autocmd FileType go nmap <silent> <Leader>gv <Plug>(go-doc-vertical)
  autocmd FileType go nmap <silent> <Leader>gb <Plug>(go-build)
  autocmd FileType go nmap <silent> <Leader>r <Plug>(go-run)
  autocmd FileType go nmap <silent> <Leader>t <Plug>(go-test)
  autocmd FileType go nmap <silent> <leader>c <Plug>(go-coverage-toggle)
  autocmd FileType go nmap <silent> <Leader>e <Plug>(go-rename)
  autocmd FileType go nmap <silent> <leader>i <Plug>(go-install)
  autocmd FileType go nmap <silent> <Leader>s <Plug>(go-implements)
  autocmd FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)
augroup END

"----------------
" rust.vim
"----------------
let g:rustfmt_autosave = 1

augroup rust
  autocmd!

  autocmd FileType rust nmap <buffer> gd         <Plug>(rust-def)
  autocmd FileType rust nmap <buffer> gs         <Plug>(rust-def-split)
  autocmd FileType rust nmap <buffer> gx         <Plug>(rust-def-vertical)
  autocmd FileType rust nmap <buffer> gt         <Plug>(rust-def-tab)
  autocmd FileType rust nmap <buffer> <leader>gd <Plug>(rust-doc)
augroup END

"----------------
" vim-racer
"----------------
let g:racer_experimental_completer = 1

"----------------
" vim-ruby
"----------------
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

"----------------
" FZF
"----------------
nnoremap <leader>. :FZF<CR>
let g:fzf_layout = { 'down': '~20%' }

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

command! FZFBuffer call fzf#run(fzf#wrap({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ }))

nnoremap <silent> <Leader>b :FZFBuffer<CR>
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
