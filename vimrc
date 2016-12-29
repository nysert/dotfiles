execute pathogen#infect()

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

set background=dark
colorscheme hybrid_material

" vim-airline config
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#enabled=0

" Keybinds
:command Ffc FufCoverageFile 

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
let g:winresizer_start_key = '<C-E>'
