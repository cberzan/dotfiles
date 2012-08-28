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

" Default indentation.
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
" TODO 4 normally and 2 for html / css

set guifont=Monospace\ 11

" Y copies till the end of the line.
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

set wildmenu
" set wildignore+=*.hi,*.o,*.e

" let's get rid of bad habits
set visualbell

" Default textwidth.
set textwidth=79
au FileType html set textwidth=0
au FileType htmldjango set textwidth=0

" Macro to add nice underlining to titles.
:call setreg('u', 'yypVr-A---')

" Macro to do include-guard boilerplate.
:call setreg('i', 'bywI#ifndef o#define po#endif // pkko')

" Arduino
au BufNewFile,BufRead *.pde set syntax=arduino

" Easy plugins with vim-pathogen.
call pathogen#infect()

" ctags
set tags=./tags;$HOME

" Keep some lines below and above the cursor.
set scrolloff=5

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

" Allow opening files with incomplete paths (e.g. open bla/bla/a/b when a/b is
" under cursor).
:map gf :e **/<cfile><cr>

" F6 toggles paste mode.
set pastetoggle=<F6>

" Turn off line numbering for the error buffer
au BufReadPost quickfix setlocal nonumber

" Account-specific stuff not stored in git.
if filereadable(glob("~/.vim_private"))
    source ~/.vim_private
endif
