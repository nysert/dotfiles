call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'glepnir/zephyr-nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'simeji/winresizer'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'

call plug#end()

colorscheme zephyr

command! W w

highlight LineNr guifg=#bbc2cf
highlight CursorLineNr guifg=#bbc2cf
highlight TabLineSel guibg=#101214

set number
set nohlsearch
set relativenumber
set virtualedit=""
set whichwrap+=<,>,h,l
set scrolloff=0
set mouse=a
set nomousehide
set termguicolors
set lazyredraw
set clipboard=unnamedplus

" -------- Normal Mode --------
nnoremap <C-e> 5<C-e>             " Scroll down 5 lines
nnoremap <C-y> 5<C-y>             " Scroll up 5 lines
nnoremap <C-j> 5gj
nnoremap <C-k> 5gk
nnoremap <C-h> gT                 " Previous tab
nnoremap <C-l> gt                 " Next tab
nnoremap <silent> <leader>bv :vnew<CR>   " Vertical split
nnoremap <C-n> :nohls<CR>         " Clear search highlight
nnoremap Y yy

" -------- Insert Mode --------
inoremap ( ()<ESC>ha
inoremap { {}<ESC>ha
inoremap [ []<ESC>ha
inoremap " ""<ESC>ha
inoremap ' ''<ESC>ha
inoremap <% <%%><ESC>2ha

" -------- Paste Mode Toggle --------
nnoremap <F2> :set invpaste paste?<CR>
set showmode     " (optional) shows -- INSERT -- etc. on the last line (default in Neovim)

" nvim-tree/nvim-tree.lua
command! NERDTree NvimTreeToggle

" nvim-telescope/telescope.nvim
nnoremap <C-f> <cmd>Telescope find_files<cr>

" simeji/winresizer
let g:winresizer_start_key = '<C-x>'

" terryma/vim-multiple-cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_exit_from_visual_mode=1
let g:multi_cursor_exit_from_insert_mode=1
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" airblade/vim-gitgutter
autocmd VimEnter * :GitGutterDisable | wincmd l
nmap <C-g> :GitGutterToggle<CR>

" CopyForLLM
function! CopyForLLM()
  let l:filepath = expand('%:.')
  execute 'normal! ggVG"+y'
  let l:content = getreg('+')
  let l:content = substitute(l:content, '\v\C^\s*\n', '', 'g')
  let l:content = substitute(l:content, '\v\C\n\s*$', '', 'g')
  let l:prompt = "on file " . l:filepath . ":\n\"\"\"\n" . l:content . "\n\"\"\"\n\n"
  call setreg('+', l:prompt)
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


lua << EOF
-- nvim-tree/nvim-tree.lua
local nvim_tree = require("nvim-tree")
local nvim_tree_api = require("nvim-tree.api")
nvim_tree.setup({
  view = {
    number = true,
    relativenumber = true,
  },
  on_attach = function(bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }

    vim.keymap.set('n', 'a', function() nvim_tree_api.fs.create() end, opts)            -- create
    vim.keymap.set('n', 'd', function() nvim_tree_api.fs.remove() end, opts)            -- delete
    vim.keymap.set('n', 'r', function() nvim_tree_api.fs.rename() end, opts)            -- rename
    vim.keymap.set('n', 'm', function() nvim_tree_api.fs.cut() end, opts)               -- move (cut)
    vim.keymap.set('n', 'p', function() nvim_tree_api.fs.paste() end, opts)             -- paste (for move)
    vim.keymap.set('n', 'x', function() nvim_tree_api.fs.copy() end, opts)              -- copy
    vim.keymap.set('n', '<CR>', function() nvim_tree_api.node.open.edit() end, opts)    -- open
    vim.keymap.set('n', 's', function() nvim_tree_api.node.open.horizontal() end, opts) -- split
    vim.keymap.set('n', 'v', function() nvim_tree_api.node.open.vertical() end, opts)   -- vsplit
    vim.keymap.set("n", "t", function() nvim_tree_api.node.open.tab() end, opts)        -- new tab foreground
    vim.keymap.set("n", "T", function()                                                 -- new tab background
      local node = nvim_tree_api.tree.get_node_under_cursor()
      if not node then return end

      local curtab = vim.api.nvim_get_current_tabpage()
      vim.cmd("tabedit " .. vim.fn.fnameescape(node.absolute_path))
      vim.api.nvim_set_current_tabpage(curtab)
    end, opts)
  end,
})

-- nvim-telescope/telescope.nvim
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
}
EOF
