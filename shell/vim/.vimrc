"
" {{{ # Notes
" +----------------------------------------------------------------------------
" .vimrc by Florian Blasel
" Just a rugh part of vim settings
" For developer you may also check:
" https://github.com/tpope/vim-pathogen (for usage of custom plugins)
" https://github.com/vim-syntastic/syntastic (syntax checks)
" https://github.com/scrooloose/nerdtree (left dir/file browser)
" https://github.com/Xuyuanp/nerdtree-git-plugin (status of files in the tree)
" https://github.com/tpope/vim-fugitive (cool git integration)
" For PHP:
" http://blog.joncairns.com/2012/05/using-vim-as-a-php-ide/
" http://www.vim.org/scripts/script.php?script_id=3125 (old, 2005)
" +----------------------------------------------------------------------------
" }}}

" # Local load & bootstrap

" {{{ ## Source local settings
"if [ -f ~/.vimrc.local ]; then source ~/.vimrc.local if
" }}}

" {{{ ## Editor settings

" Auto expand tabs to spaces
set expandtab

" Use filetype plugins, e.g. for PHP
filetype plugin indent on

" Show nice info in ruler
set ruler
set laststatus=3

" Set standard setting for PEAR coding standards
set tabstop=4
set shiftwidth=4

" Show line numbers by default
"set number

" Enable folding by fold markers
set foldmethod=marker

" Autoclose folds, when moving out of them
set foldclose=all

" Use incremental searching
set incsearch

" Do not highlight search results
set nohlsearch

" Jump 5 lines when running out of the screen
set scrolljump=5

" Indicate jump out of the screen when 3 lines before end of the screen
set scrolloff=3

" Repair wired terminal/vim settings
set backspace=start,eol,indent

" Allow file inline modelines to provide settings
set modeline


" }}}


" # Features

" {{{ ## general

" show matching brackets/parenthesis
set showmatch

" highlight search terms
set hlsearch

" History (default is 20)
set history=1000

" Set new grep command, which ignores SVN!
" TODO: Add this to SVN
"set grepprg=/usr/bin/vimgrep\ $*\ /dev/null

" Highlight current line in insert mode.
autocmd InsertLeave * se nocul
autocmd InsertEnter * se cul
" }}}


" {{{ ## for php
"
" Reads the skeleton php file
" Note: The normal command afterwards deletes an ugly pending line and moves
" the cursor to the middle of the file.
autocmd BufNewFile *.php :0r ~/.vim/templates/skeleton.php
autocmd BufNewFile *.phps :0r ~/.vim/templates/skeleton.php

" .phps files handled like .php
au BufRead,BufNewFile *.phps        set filetype=php

" }}}


" The plugin to enable custom plugins then, see below
" # read, install: https://github.com/tpope/vim-pathogen
execute pathogen#infect()


" {{{ ## for syntastic
" :help syntastic
" @see https://github.com/vim-syntastic/syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"# let g:syntastic_php_phpcs_args = "--standard=Zend --tab-width=0"
let g:syntastic_php_phpcs_args = "--standard=misc/coding/Mumsys2"

" }}}


" {{{ ## for NERDTree
" to enable manually: :NERDTree [/path|.]

"autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" }}}


" {{{ ## for vim-fugitive (cool git integration)
"set statusline+=%{fugitive#statusline()}
" }}}

