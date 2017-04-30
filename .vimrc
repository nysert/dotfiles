set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/FuzzyFinder'
Plugin 'vim-scripts/L9'
Plugin 'slashmili/alchemist.vim'
Plugin 'mattn/emmet-vim'
Plugin 'yggdroot/indentline'
Plugin 'aluriak/nerdcommenter'
Plugin 'vim-airline/vim-airline'
Plugin 'elixir-lang/vim-elixir'
Plugin 'tpope/vim-fugitive'
Plugin 'kristijanhusak/vim-hybrid-material'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'simeji/winresizer'
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set number
syntax on
set encoding=utf-8
set guifont=Source\ Code\ Pro\ for\ Powerline
" autocmd BufEnter * lcd %:p:h
set backspace=2
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set term=screen-256color
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list

" add (), {}, [], "", '', <%%>  autocompletion
inoremap ( ()<ESC>ha
inoremap { {}<ESC>ha
inoremap [ []<ESC>ha
inoremap " ""<ESC>ha
inoremap ' ''<ESC>ha
inoremap <% <%%><ESC>2ha

" paste togle visual
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

set background=dark
colorscheme hybrid_material

" vim-airline config
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#enabled=0

" Keybinds
:command Ffc FufCoverageFile 
nmap <C-f> :FufCoverageFile<CR>

" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" set relative and line number together
set relativenumber 
:highlight LineNr ctermfg=grey   

" indentline
let g:indentLine_char='|'
"let g:indentLine_leadingSpaceChar = '.'
"let g:indentLine_leadingSpaceEnabled = 1 

" NEERDTree 
let NERDTreeShowHidden=1

" vim-multiple-cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" NERDCommenter
filetype plugin on

" winresizer
let g:winresizer_start_key = '<C-x>'
