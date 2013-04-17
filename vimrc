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

" *arpeggio mappings {{{1

" Force plugin to load now, instead of after ~/.vimrc is finished processing.
call arpeggio#load()

" *very common operations* {{{2
Arpeggio inoremap jk <Esc>
Arpeggio noremap jf :w<CR>
Arpeggio noremap we :noh<CR>
"}}}

" *windows and buffers* {{{2
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

Arpeggio noremap go :LustyJuggler<CR>
Arpeggio noremap gp :CommandT<CR>
Arpeggio noremap gt :NERDTreeToggle<CR>
"}}}

" *TODO clean up* {{{2
Arpeggio noremap ei :Gstatus<CR>
Arpeggio noremap bui :CommandTBuffer<CR>
Arpeggio noremap wer :set filetype=
Arpeggio noremap uw viwu
Arpeggio noremap UW viwU
Arpeggio noremap tr Oimport ipdb; ipdb.set_trace()<Esc>V=
"}}}

"}}}


" Fun with windows and buffers.
set hidden
noremap <Leader>j :LustyJuggler<CR>

" TODO:
" - bring arpeggio mappings here, if possible; otherwise integrate with
"   dotfiles repo
" - cnk-style auto folds?
" - make a minimal version that would work on a foreign machine where I don't
"   want to install stuff
" - on a new machine where I want my full setup, make it easy to pull in
"   pathogen, plugins, etc.

" Account-specific stuff not stored in git.
if filereadable(glob("~/.vim_private"))
    source ~/.vim_private
endif
