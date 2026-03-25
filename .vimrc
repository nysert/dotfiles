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
Plugin 'kien/ctrlp.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'jremmen/vim-ripgrep'
Plugin 'leafgarland/typescript-vim'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'fatih/vim-go'
Plugin 'neoclide/coc.nvim'

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
" >>> kristijanhusak/vim-hybrid-material
colorscheme hybrid_material
"set termguicolors
"autocmd VimEnter * highlight Normal guibg=#262a33
"autocmd VimEnter * highlight Normal guibg=#262a33
"autocmd VimEnter * highlight LineNr guibg=#262a33
"autocmd VimEnter * highlight SignColumn guibg=#262a33
"autocmd VimEnter * highlight VertSplit guibg=#262a33
"autocmd VimEnter * highlight StatusLine guibg=#262a33
"autocmd VimEnter * highlight StatusLineNC guibg=#262a33
" <<<< kristijanhusak/vim-hybrid-material
set nohlsearch
set colorcolumn=100
set relativenumber
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
nnoremap <C-n> :nohls<CR>

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
let g:ctrlp_working_path_mode = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
\ 'dir':  'node_modules\|\.git\|\.next\|ios/Pods\|ios/Index\|*.xcodeproj\|\.xcworkspace\|deps\|cache\|bundle\|vendor\|tmp\|public\/packs\|public\/packs-test\|public\/system\|\.sass-cache\|venv',
\ 'file': '\v\.(exe|so|dll)$',
\ }
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
let g:multi_cursor_exit_from_visual_mode=1
let g:multi_cursor_exit_from_insert_mode=1
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

" ripgrep
let g:rg_highlight = 1

" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" CopyForLLM
function! CopyForLLM()
  let l:pos = getpos('.')
  let l:filepath = expand('%:.')
  execute 'normal! ggVG"+y'
  let l:content = getreg('+')
  let l:content = substitute(l:content, '\v\C^\s*\n', '', 'g')
  let l:content = substitute(l:content, '\v\C\n\s*$', '', 'g')
  let l:prompt = "on file " . l:filepath . ":\n\"\"\"\n" . l:content . "\n\"\"\"\n\n"
  call setreg('+', l:prompt)
  call setpos('.', l:pos)
endfunction
command! CLLM call CopyForLLM()

" CopyForLLMDir
function! CopyForLLMDir(dir, tracked) abort
  if empty(a:dir) | echoerr 'Usage: :DirLLM[!] {dir}' | return | endif
  let l:pos = getpos('.')
  let l:root = fnamemodify(expand(a:dir, 1), ':p')
  if !isdirectory(l:root) | echoerr 'Not a directory: ' . a:dir | return | endif

  " Collect files (git-tracked if bang used)
  let l:files = []
  if a:tracked && executable('git')
        \ && (isdirectory(l:root.'/.git') || !empty(system('git -C '.shellescape(l:root).' rev-parse --is-inside-work-tree 2> /dev/null')))
    let l:raw = systemlist('git -C '.shellescape(l:root).' ls-files -z')
    if v:shell_error == 0
      let l:files = split(join(l:raw, ''), '\x00')
      let l:files = map(l:files, {_,f -> empty(f)? '' : fnamemodify(l:root.'/'.f, ':p')})
      let l:files = filter(l:files, {_,f -> !empty(f) && filereadable(f)})
    endif
  endif
  if empty(l:files)
    let l:all = globpath(l:root, '**/*', 0, 1)
    let l:files = filter(copy(l:all), {_,v -> filereadable(v)})

    let l:exclude_dir_pat  = '\v/(\.git|node_modules|dist|build|target|out|coverage|\.venv|\.tox|\.mypy_cache|\.pytest_cache|\.cache|__pycache__)(/|$)'
    let l:exclude_name_pat = '\v(^|/)\.(DS_Store|_?env$|idea|vscode)(/|$)'
    let l:exclude_ext_pat  = '\v\.(pyc|pyo|pyd|o|obj|a|so|dylib|dll|class|jar|war|wasm|lock|log|tmp|swp|swo|orig|bak|rej'
          \ . '|png|jpe?g|gif|bmp|webp|ico|pdf|zip|t(ar|gz)|bz2|7z|rar|xz'
          \ . '|mp3|wav|flac|mp4|mov|avi|mkv|webm|woff2?|ttf|otf)$'
    let l:files = filter(l:files, {_,f -> f !~# l:exclude_dir_pat && f !~# l:exclude_name_pat && f !~? l:exclude_ext_pat})

    " Optional include-only allowlist:
    " let l:include_ext_pat = '\v\.(md|txt|py|vim|lua|sh|zsh|js|jsx|ts|tsx|json|yml|yaml|toml|rb|go|rs|java|kt|c|h|cpp|hpp|sql|html|css|scss)$'
    " let l:files = filter(l:files, {_,f -> f =~? l:include_ext_pat})
  endif

  call sort(l:files)

  let l:max_bytes = 800 * 1024
  let l:total = 0
  let l:out = []
  for l:f in l:files
    try | let l:lines = readfile(l:f, 'b') | catch | continue | endtry
    let l:content = join(l:lines, "\n")
    let l:content = substitute(l:content, '\v\C^\s*\n', '', 'g')
    let l:content = substitute(l:content, '\v\C\n\s*$', '', 'g')
    if empty(l:content) | continue | endif
    let l:rel = fnamemodify(l:f, ':.')
    let l:block = 'on file ' . l:rel . ":\n\"\"\"\n" . l:content . "\n\"\"\"\n\n"
    if l:total + strlen(l:block) > l:max_bytes
      call add(l:out, "\n---\n[truncated: size cap reached]") | break
    endif
    call add(l:out, l:block)
    let l:total += strlen(l:block)
  endfor

  if empty(l:out)
    echohl WarningMsg | echom 'No non-empty text files collected.' | echohl None
    call setpos('.', l:pos)
    return
  endif

  let l:bundle = join(l:out, '')

  " Copy to clipboard(s) only; no buffers opened
  if has('clipboard')
    try | call setreg('+', l:bundle) | catch | endtry
    try | call setreg('*', l:bundle) | catch | endtry
  else
    " Fallback: unnamed register so you can :put
    call setreg('"', l:bundle)
  endif

  call setpos('.', l:pos)
  echom 'Copied ' . len(l:out) . ' file blocks (~' . printf('%.1f', l:total/1024.0) . ' KB) to clipboard.'
endfunction
command! -nargs=1 -bang -complete=dir DirLLM call CopyForLLMDir(<f-args>, <bang>0)
command! -nargs=1 -bang -complete=dir DIrLLM call CopyForLLMDir(<f-args>, <bang>0)
command! -nargs=1 -bang -complete=dir DIRLLM call CopyForLLMDir(<f-args>, <bang>0)

" ======================
" ====== coc.nvim ======
" ======================
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)
" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" ======================
" ====== coc.nvim ======
" ======================
