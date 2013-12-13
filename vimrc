" .vimrc
"
" TODO:
" - FIXME: up arrow behaves like O on linux
" - don't split lines after a one-letter word
" - jk arpeggio shortcut doesn't work in visual mode
" - lusty emits an error message when vim started as `editor` (e.g. by git commit)
" - abbreviations for custom snippets
" - make a minimal version that would work on a foreign machine where I don't
"   want to install stuff
"

" basics {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
set number                  " line numbers
set ruler                   " coordinates in bottom-right corner
set ignorecase
set hlsearch
set incsearch               " EXPERIMENTING
set smartcase
syntax on
set background=light
set laststatus=2            " always show status line
set hidden                  " allow more buffers than windows
set modeline
set wildmenu                " show menu for command-line completion
set scrolloff=5             " keep some lines below and above the cursor
set linebreak               " don't break lines in the middle of a word
set formatoptions-=o        " don't continue comments when pressing o/O


" Y copies till the end of the line (can't have comment after the line, since
" white space is significant -- it makes the cursor move).
noremap Y y$

call pathogen#infect()      " makes plugin installation simple
set tags=./tags;$HOME       " ctags

set undolevels=100000

let NERDSpaceDelims=1       " comment with '# ' instead of just '#'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" editing settings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set textwidth=79

set autoindent              " new line like previous line
set nosmartindent

" default indentation (may be overriden by filetype-specific settings)
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" filetype-specific settings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin on
filetype indent off

function! SetTwoSpaceMode()
    setlocal softtabstop=2
    setlocal tabstop=2
    setlocal shiftwidth=2
endfunction

" Python
au FileType python set formatoptions+=cro

" Makefile
au FileType make set noexpandtab

" CSS
au FileType css call SetTwoSpaceMode()

" HTML
au FileType html set textwidth=0
au FileType html call SetTwoSpaceMode()
au FileType htmldjango set textwidth=0
au FileType htmldjango call SetTwoSpaceMode()

" Markdown
au BufRead,BufNewFile *.md set filetype=markdown
let g:instant_markdown_autostart = 0
let g:instant_markdown_slow = 1

" Arduino
au BufNewFile,BufRead *.pde set syntax=arduino

" Error buffer
au BufReadPost quickfix setlocal nonumber

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" shortcuts {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set pastetoggle=<F6>        " toggle paste mode
map <F2> :cprevious<CR>
map <F3> :cnext<CR>
" FIXME: the below fails silently if codequality is not installed.
" perhaps replace it with a function?
map <F4> :w<CR>:let old_makeprg = &makeprg<CR>:set makeprg=codequality\ %<CR>:make<CR>:let &makeprg = old_makeprg<CR>:cwindow<CR><CR>
map <F9> :w<CR>:make<CR>
map gf :e **/<cfile><cr>    " allow opening files with incomplete paths
                            " (e.g. open bla/bla/a/b when a/b is under cursor)

" Can still save if I forget sudo.
cmap w!! %!sudo tee > /dev/null %

" Alt+o / Alt+O to make a new line without entering insert mode.
" Mapping <M-o> and <M-O> doesn't do squat, because terminals insert weird
" characters when you press those keys.
" Linux (FIXME: this makes the arrow keys insert lines...)
" noremap o o<Esc>
" noremap O O<Esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" abbreviations {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Pressing <Tab> or <Space> or <Enter> after one of these will
" still insert the tab / space / newline after the abbreviation.

" (:help abbrev and search for "non-id" for some fun restrictions)

" shebangs
iabbrev bash# #!/bin/bash
iabbrev py# #!/usr/bin/env python

" Python misc
iabbrev pyma if __name__ == "__main__":
iabbrev py* print "*" * 78  # XXX
iabbrev ipdb; import ipdb; ipdb.set_trace()  # XXX

" Python imports
iabbrev inpy import numpy as np
iabbrev iplt import matplotlib.pyplot as plt
iabbrev iimg import matplotlib.image as mpimg

" Python nose
iabbrev nae nose.tools.assert_equal
iabbrev nat nose.tools.assert_true
iabbrev naf nose.tools.assert_false
iabbrev nai nose.tools.assert_in

" TODO port this macro to do include-guard boilerplate.
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

" Note: Can't put indented comments after the line,
" since the spaces cause the cursor to move!
" Note: On OSX, use * instead of +.
" Copy entire file to system clipboard:
Arpeggio noremap gy :%y+<CR>
" Copy selection to system clipboard:
Arpeggio vnoremap gy "+y
" Comment lines:
Arpeggio noremap co :call NERDComment(0, "AlignLeft")<CR>
" Uncomment lines:
Arpeggio noremap cu :call NERDComment(0, "Uncomment")<CR>
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
Arpeggio noremap gp :LustyJugglePrevious<CR>
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

" vim: set foldmethod=marker:
