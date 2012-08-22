" .vimrc

set number
filetype indent on
set ignorecase
set hlsearch
set smartcase
syntax on
map <F9> :w<CR>:make<CR>
map <F3> :lne<CR>
map <S-F3> :lp<CR>

set laststatus=2

set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

set guifont=Monospace\ 11

:map Y y$

set modeline

au FileType haskell set autoindent
au FileType haskell set makeprg=ghc\ --make\ %
au FileType haskell set suffixes+=,,.hi

" Enable plugins
set nocp 
filetype plugin on
set ofu=syntaxcomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" To make Align keep white space at the beginning:
" No idea why it doesn't work here...
" AlignCtrl =lp1P1W

" something overrides it...
set expandtab

set wildmenu
" set wildignore+=*.hi,*.o,*.e

" let's get rid of bad habits
set visualbell

" I need it more often than not.
set textwidth=80

" Macro to add nice underlining to titles.
:call setreg('u', 'yypVr-A---')

" Macro to do include-guard boilerplate.
:call setreg('i', 'bywI#ifndef o#define po#endif // pkko')

" Arduino
au BufNewFile,BufRead *.pde set syntax=arduino

" Easy plugins with vim-pathogen.
call pathogen#infect()
