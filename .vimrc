" ==================================================================================================
" Vundle Initialization
" Avoid modifying this section unless you are very sure of what you are doing

" no vi-compatible
set nocompatible

" Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let iCanHazVundle=0
endif

filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" ==================================================================================================
" Add all your plugins here
Bundle 'altercation/vim-colors-solarized'
" ==================================================================================================

call vundle#end()		" Required
filetype plugin indent on	" Required

syntax enable
set background=dark
let g:solarized_termcolors = 256
colorscheme solarized
