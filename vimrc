" .vimrc
"
" TODO:
" - make a minimal version that would work on a foreign machine where I don't
"   want to install stuff
" - on a new machine where I want my full setup, make it easy to pull in
"   pathogen, plugins, etc.

" basics {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
set number
filetype indent on
filetype plugin on
set ignorecase
set hlsearch
set smartcase
syntax on
set laststatus=2            " always show status line
set hidden                  " allow more buffers than windows
set clipboard=unnamed       " use system clipboard for copy/paste
set foldmethod=marker       " automatically fold at {{{ }}} markers
map Y y$                    " Y copies till the end of the line
set modeline
set wildmenu                " show menu for command-line completion
set scrolloff=5             " keep some lines below and above the cursor

call pathogen#infect()          " makes plugin installation simple

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" editing settings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set textwidth=79

" Default indentation.
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
" TODO 4 normally and 2 for html / css

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" filetype-specific settings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ctags
set tags=./tags;$HOME

" Allow long lines for HTML.
au FileType html set textwidth=0
au FileType htmldjango set textwidth=0

" Turn off line numbering for the error buffer.
au BufReadPost quickfix setlocal nonumber

" Arduino
au BufNewFile,BufRead *.pde set syntax=arduino

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" shortcuts {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set pastetoggle=<F6>        " toggle paste mode
map <F9> :w<CR>:make<CR>
map gf :e **/<cfile><cr>    " allow opening files with incomplete paths
                            " (e.g. open bla/bla/a/b when a/b is under cursor)
cmap w!! %!sudo tee > /dev/null %       " can still save if I forget sudo

" Macro to do include-guard boilerplate.
" TODO use snippets instead
" :call setreg('i', 'bywI#ifndef o#define po#endif // pkko')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" purgatorium {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map <F3> :lne<CR>
" map <S-F3> :lp<CR>
" set guifont=Monospace\ 11

" au FileType haskell set autoindent
" au FileType haskell set makeprg=ghc\ --make\ %
" au FileType haskell set suffixes+=,,.hi
" set wildignore+=*.hi,*.o,*.e

" set ofu=syntaxcomplete#Complete
" autocmd FileType python set omnifunc=pythoncomplete#Complete
" autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
" autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" This is a good idea in theory, but didn't work well when I tried it.
" set visualbell              " let's get rid of bad habits

" Macro to add nice underlining to titles.
" :call setreg('u', 'yypVr-A---')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" arpeggio mappings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Force plugin to load now, instead of after ~/.vimrc is finished processing.
call arpeggio#load()

" very common operations {{{2
Arpeggio inoremap jk <Esc>
Arpeggio noremap jf :w<CR>
Arpeggio noremap we :noh<CR>
Arpeggio noremap sf :set filetype=
"}}}

" windows and buffers {{{2
Arpeggio noremap wj <C-w>j
Arpeggio noremap wk <C-w>k
Arpeggio noremap wl <C-w>l
Arpeggio noremap wh <C-w>h

Arpeggio noremap WJ <C-w>J
Arpeggio noremap WK <C-w>K
Arpeggio noremap WL <C-w>L
Arpeggio noremap WH <C-w>H

Arpeggio noremap ws <C-w>s
Arpeggio noremap wv <C-w>v
Arpeggio noremap wq <C-w>q

Arpeggio noremap gj :LustyJuggler<CR>
Arpeggio noremap gh :CommandT<CR>
Arpeggio noremap gt :NERDTreeToggle<CR>
"}}}

" TODO clean up {{{2
Arpeggio noremap ei :Gstatus<CR>
Arpeggio noremap bui :CommandTBuffer<CR>
Arpeggio noremap uw viwu
Arpeggio noremap UW viwU
Arpeggio noremap tr Oimport ipdb; ipdb.set_trace()<Esc>V=
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"}}}

" leader commands {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Most of these also have arpeggio shortcuts.
noremap <Leader>j :LustyJuggler<CR>
" <Leader>t opens :CommandT

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" account-specific stuff not stored in git {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable(glob("~/.vim_private"))
    source ~/.vim_private
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
