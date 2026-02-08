" UI
set nocompatible
set title
set encoding=utf-8
set showcmd
set number
set relativenumber
set cursorline
set textwidth=80
set laststatus=2
set wildignorecase
set nowrap

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault

" Indenting
set smartindent
set expandtab
set shiftwidth=2
set tabstop=2
set smarttab
set copyindent

" Misc
set scrolloff=4
set backspace=indent,eol,start
set diffopt=iwhite
set tabpagemax=100

" Leader key
let mapleader = " "

" Mouse support
set mouse=a

" Faster UI updates
set ttyfast

" Allow arrow/backspace across lines
set whichwrap=bs<>[]

" Enable syntax and filetype detection
syntax enable
filetype plugin indent on

" Netrw
let g:netrw_banner = 0