" Neovim config.

" basics {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number
set ignorecase
set smartcase
set linebreak               " don't break lines in the middle of a word
set scrolloff=5             " keep some lines below and above the cursor
set undolevels=100000
set textwidth=79
set autoindent              " new line like previous line
set nosmartindent
set foldmethod=marker       " automatically close marked folds in files
set hidden                  " required by LustyJuggler

" default indentation (may be overriden by filetype-specific settings)
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Y copies till the end of the line (can't have comment after the line, since
" white space is significant -- it makes the cursor move).
noremap Y y$

" plugin settings
let NERDSpaceDelims=1       " comment with '# ' instead of just '#'

" Stuff from old vimrc that I'm not sure I need...
" set tags=./tags;$HOME       " ctags
" set formatoptions-=o        " don't continue comments when pressing o/O

" Smarter tab completion in the command line.
" (command-t also respects the wildignore list).
" set wildmenu
" set wildignore=*~,*.o,*.class,*.pyc

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

" JavaScript
au FileType javascript call SetTwoSpaceMode()

" Java (google style doc says 2 spaces)
au FileType java call SetTwoSpaceMode()

" Scala
au FileType scala call SetTwoSpaceMode()

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

map <F9> :w<CR>:make<CR>
map gf :e **/<cfile><cr>    " allow opening files with incomplete paths
                            " (e.g. open bla/bla/a/b when a/b is under cursor)

" Can still save if I forget sudo.
cmap w!! %!sudo tee > /dev/null %

" Old stuff; not sure I still need any of this:
"
" set pastetoggle=<F6>        " toggle paste mode
"
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
iabbrev pinit def __init__(self):

" Python imports
iabbrev inpy import numpy as np
iabbrev iplt import matplotlib.pyplot as plt
iabbrev iimg import matplotlib.image as mpimg
iabbrev ictr from collections import Counter
iabbrev idd from collections import defaultdict
iabbrev idt import datetime
iabbrev intup from collections import namedtuple

" Python nose
iabbrev nae nose.tools.assert_equal
iabbrev naae nose.tools.assert_almost_equals
iabbrev nat nose.tools.assert_true
iabbrev naf nose.tools.assert_false
iabbrev nai nose.tools.assert_in

" Java misc
iabbrev pln System.out.println

" TODO port this macro to do include-guard boilerplate.
" :call setreg('i', 'bywI#ifndef o#define po#endif // pkko')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" arpeggio mappings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Force plugin to load now, instead of after ~/.vimrc is finished processing.
:packloadall
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

" Flake8:
Arpeggio noremap pf :call Flake8()<CR>
Arpeggio noremap zn :cnext<CR>
Arpeggio noremap zp :cprev<CR>
Arpeggio noremap PF :cclose<CR>

" YAPF:
Arpeggio noremap fo :YAPF<CR>

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
" Arpeggio noremap ei :Gstatus<CR>
" Arpeggio noremap bui :CommandTBuffer<CR>
" Arpeggio noremap uw viwu
" Arpeggio noremap UW viwU
" Arpeggio noremap tr Oimport ipdb; ipdb.set_trace()<Esc>V=
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"}}}

" leader commands {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Most of these also have arpeggio shortcuts.
" noremap <Leader>j :LustyJuggler<CR>
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

