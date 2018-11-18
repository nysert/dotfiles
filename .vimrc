set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/L9'
Plugin 'slashmili/alchemist.vim'
Plugin 'mattn/emmet-vim'
Plugin 'aluriak/nerdcommenter'
Plugin 'vim-airline/vim-airline'
Plugin 'simeji/winresizer'
Plugin 'airblade/vim-gitgutter'
Plugin 'kristijanhusak/vim-hybrid-material'
Plugin 'fatih/vim-go'
Plugin 'kien/ctrlp.vim'
Plugin 'wakatime/vim-wakatime'
Plugin 'sheerun/vim-polyglot'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set number
syntax on
set encoding=utf-8
set guifont=Source\ Code\ Pro\ for\ Powerline
set backspace=2
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list
set background=dark
colorscheme hybrid_material
set colorcolumn=100
set relativenumber
set nohlsearch
:highlight LineNr ctermfg=grey

command W w

" Normal Mode
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
nnoremap <C-j> 5j
nnoremap <C-k> 5k
nnoremap <C-h> gT
nnoremap <C-l> gt
nnoremap <silent> <leader>bv :vnew<CR>

" Insert Mode
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

" ctrlp.vim
let g:ctrlp_map = '<c-f>'
let g:ctrlp_custom_ignore = 'node_modules\|build\|ios/Pods\|ios/Index\|*.xcodeproj\|.xcworkspace\|deps\|cache\|_build\|vendor\'
let g:ctrlp_prompt_mappings = {
\  'PrtClearCache()': ['<c-r>'],
\}

" NERDTree
autocmd FileType nerdtree setlocal relativenumber
let NERDTreeShowLineNumbers = 1
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['node_modules$[[dir]]']

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

" gitgutter
autocmd VimEnter :GitGutterDisable wincmd l
nmap <C-g> :GitGutterToggle<CR>

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#enabled=0
let g:airline_section_z = '%{strftime("%H:%M %d/%b/%y")}'

" emmet-vim
let g:user_emmet_mode='iv'
let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\      'quote_char': "'",
\  },
\}
