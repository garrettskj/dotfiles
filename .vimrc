"Enable Syntax coloring and use the Potato scheme
syntax on
colorscheme potato

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" Let's make searching fun!
set hlsearch
set incsearch
set ignorecase
set smartcase

" show line numbers
set number
set showcmd

" this modifies the line numbers on the left hand side
" this is useful because it will tell you how many lines for motions
set relativenumber

" Disable the default Vim startup message.
set shortmess+=I

" always show the status line at the bottom.
set laststatus=2

" Fix backspace to be more like you'd expect it to work.
set backspace=indent,eol,start

" Protected me from quitting without saving without double warning
set hidden

"Un bind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
endif
