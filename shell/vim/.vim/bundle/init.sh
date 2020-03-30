#!/bin/sh

# init the plugins docs for vim
# dont forget cd ~/.vim && git submodule init && git submodule update

# vim -u NONE -c "helptags vim-fugitive/doc" -c q
# vim -u NONE -c "helptags nerdtree/doc" -c q
# vim -u NONE -c "helptags syntastic/doc" -c q

# check for more/ all
vim -u NONE -c "helptags ALL" -c q

exit 0
