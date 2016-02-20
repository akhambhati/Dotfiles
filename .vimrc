" ==================================================================================================
" Vundle Initialization
" Avoid modifying this section unless you are very sure of what you are doing

" no vi-compatible
set nocompatible
filetype off

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


set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Plugin 'gmarik/vundle'

" ==================================================================================================
" Add all your plugins here
Plugin 'altercation/vim-colors-solarized'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'mbbill/undotree'
Plugin 'tpope/vim-fugitive'
Plugin 'davidhalter/jedi-vim'
Plugin 'Lokaltog/powerline', {'rtp':'/powerline/bindings/vim'}
" ==================================================================================================

call vundle#end()		" Required

" ==================================================================================================
" Begin VIMRC Settings
" ==================================================================================================

" General {
    set encoding=utf-8
    filetype plugin indent on               " Autodetect filetypes
    "set clipboard=unnamed                   " Use the system clipboard in conjunction with yank et al.
    "set virtualedit=onemore                 " Cursor beyond last character
    "set history=1000
    "set spell                               " Turn on spell check
    "set hidden                              " Buffer switching without saving
    "set iskeyword-=.
    "set iskeyword-=#
    "set iskeyword-=-

    " Restore cursor to file position previous editing session
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    set backup                  " Backups are nice ...
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload

    au FocusLost * :wa
" }
" --------------------------------------------------------------------------------------------


" VIM UI {
    " Solarized color scheme
    syntax enable
    set background=dark
    let g:solarized_termcolors = 256
    colorscheme solarized

    set showmode                            " Show current mode
    set tabpagemax=15                       " Maximum number of tabs
    set cursorline                          " Highlight cursor line
    highlight clear SignColumn              " SignColumn should match background
    highlight clear LineNr                  " Current line number row will have same color in relative mode

    set ruler                               " Show ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
    set showcmd

    set laststatus=2
    set statusline=%<%f\                    " Filename
    set statusline+=%w%h%m%r                " Options
    set statusline+=%{fugitive#statusline()}    " Git Hotness
    set statusline+=\ [%{&ff}/%Y]           " Filetype
    set statusline+=\ [%{getcwd()}]         " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%% " Right aligned file nav info

    set backspace=indent,eol,start          " Backspace for dummies
    set linespace=0                         " No extra spaces between rows
    set number                              " Line numbers on
    set relativenumber                      " Relative to where you are
    set showmatch                           " Show matching brackets/parenthesis
    set incsearch                           " Find as you type search
    set hlsearch                            " Highlight search terms
    set winminheight=0                      " Windows can be 0 line high
    set ignorecase                          " Case insensitive search
    set smartcase                           " Case sensitive when uc present
    set gdefault                            " Replace globally
    set wildmenu                            " Show list instead of just completing
    set wildmode=list:longest,full          " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]           " Backspace and cursor keys wrap too
    set scrolljump=5                        " Lines to scroll when cursor leaves screen
    set scrolloff=3                         " Minimum lines to keep above and below cursor
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }
" --------------------------------------------------------------------------------------------

" Formatting {

    set nowrap                      " Do not wrap long lines
    set textwidth=79
    set formatoptions=qrn1
    set colorcolumn=85
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks

    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell
" }
" --------------------------------------------------------------------------------------------

" Key Remapping {
    let mapleader = ','             " Leader is now ,

    " Use semicolon to execute vim commands
    nnoremap ; :

    " Open a new split and switch over to it
    nnoremap <leader>w <C-w>v<C-w>l

    " Moving around tabs and windows
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
    nnoremap <C-h> <C-w>h

    " Handle easier switching and moving
    nnoremap / /\v
    vnoremap / /\v

    " Clear a search
    nnoremap <leader><space> :noh<cr>
    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Move around brackets
    nnoremap <tab> %
    vnoremap <tab> %

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Disable arrow keys to help learn navigation
    nnoremap <up> <nop>
    nnoremap <down> <nop>
    nnoremap <left> <nop>
    nnoremap <right> <nop>
    inoremap <up> <nop>
    inoremap <down> <nop>
    inoremap <left> <nop>
    inoremap <right> <nop>
    nnoremap j gj
    nnoremap k gk
" }
" --------------------------------------------------------------------------------------------

" Plugins {
    " NERDTree
    nmap <leader>ne :NERDTreeFocus<cr>

    " CTRL-P
    nmap <leader>f :CtrlP<CR>

    " Undotree
    nmap <leader>u :UndotreeToggle<CR>

    " SimpylFold -- settings
    let g:SimpylFold_docstring_preview=1
" }
" --------------------------------------------------------------------------------------------

" Functions {
    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        let @/=_s
        call cursor(l, c)
    endfunction
" }
" --------------------------------------------------------------------------------------------
