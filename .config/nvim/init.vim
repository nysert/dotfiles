call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'glepnir/zephyr-nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'simeji/winresizer'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'

" LSP / docs / go-to-definition
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'

" Autocomplete from LSP
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'onsails/lspkind.nvim'

" Formatting and linting
Plug 'stevearc/conform.nvim'
Plug 'mfussenegger/nvim-lint'

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
set completeopt=menu,menuone,noselect
set pumheight=15

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

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
set showmode

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

    vim.keymap.set("n", "a", function() nvim_tree_api.fs.create() end, opts)
    vim.keymap.set("n", "d", function() nvim_tree_api.fs.remove() end, opts)
    vim.keymap.set("n", "r", function() nvim_tree_api.fs.rename() end, opts)
    vim.keymap.set("n", "m", function() nvim_tree_api.fs.cut() end, opts)
    vim.keymap.set("n", "p", function() nvim_tree_api.fs.paste() end, opts)
    vim.keymap.set("n", "x", function() nvim_tree_api.fs.copy() end, opts)
    vim.keymap.set("n", "<CR>", function() nvim_tree_api.node.open.edit() end, opts)
    vim.keymap.set("n", "s", function() nvim_tree_api.node.open.horizontal() end, opts)
    vim.keymap.set("n", "v", function() nvim_tree_api.node.open.vertical() end, opts)
    vim.keymap.set("n", "t", function() nvim_tree_api.node.open.tab() end, opts)

    vim.keymap.set("n", "T", function()
      local node = nvim_tree_api.tree.get_node_under_cursor()
      if not node then return end

      local curtab = vim.api.nvim_get_current_tabpage()
      vim.cmd("tabedit " .. vim.fn.fnameescape(node.absolute_path))
      vim.api.nvim_set_current_tabpage(curtab)
    end, opts)
  end,
})

-- nvim-telescope/telescope.nvim
local actions = require("telescope.actions")

require("telescope").setup({
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
})

-- Mason: installs/manages language servers like clangd, rust_analyzer, ts_ls, etc.
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    -- C / C++
    "clangd",

    -- Rust
    "rust_analyzer",

    -- JavaScript / TypeScript
    "ts_ls",
    "eslint",

    -- Go
    "gopls",

    -- Ruby
    "ruby_lsp",

    -- Elixir
    "elixirls",
  },
})

-- External formatter/linter CLIs managed by Mason
local ok_mason_tools, mason_tool_installer = pcall(require, "mason-tool-installer")
if ok_mason_tools then
  mason_tool_installer.setup({
    ensure_installed = {
      -- C / C++
      "clang-format",

      -- JavaScript / TypeScript
      "prettier",
      "eslint_d",
      "biome",

      -- Go
      "goimports",
      "gofumpt",
      "golangci-lint",

      -- Ruby
      "rubocop",
      "standardrb",
    },
  })
end

-- Completion capabilities for LSP
local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")
local lspkind = require("lspkind")
local capabilities = cmp_lsp.default_capabilities()

local function truncate(str, max_width)
  if not str then
    return ""
  end

  if vim.fn.strdisplaywidth(str) <= max_width then
    return str
  end

  return vim.fn.strcharpart(str, 0, max_width - 1) .. "…"
end

local function clean_signature(str)
  if not str then
    return ""
  end

  -- Remove markdown emphasis used to highlight active params.
  -- Do NOT remove single *, because C++ pointers use it.
  str = str:gsub("%*%*%*(.-)%*%*%*", "%1")
  str = str:gsub("%*%*(.-)%*%*", "%1")
  str = str:gsub("___(.-)___", "%1")
  str = str:gsub("__(.-)__", "%1")

  return str
end

-- Custom signature source.
-- This avoids cmp-nvim-lsp-signature-help scrolling to clangd's active signature.
local signature_source = {}

signature_source.new = function()
  return setmetatable({}, { __index = signature_source })
end

signature_source.is_available = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
    method = "textDocument/signatureHelp",
  })

  return #clients > 0
end

signature_source.complete = function(_, _, callback)
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
    method = "textDocument/signatureHelp",
  })

  if #clients == 0 then
    callback({ items = {}, isIncomplete = false })
    return
  end

  local offset_encoding = clients[1].offset_encoding or "utf-16"
  local params = vim.lsp.util.make_position_params(0, offset_encoding)

  vim.lsp.buf_request_all(bufnr, "textDocument/signatureHelp", params, function(results)
    local items = {}

    for _, response in pairs(results) do
      local result = response.result

      if result and result.signatures then
        for index, sig in ipairs(result.signatures) do
          local label = clean_signature(sig.label or "")

          table.insert(items, {
            label = label,
            word = "",
            insertText = "",
            kind = vim.lsp.protocol.CompletionItemKind.Function,
            documentation = sig.documentation,
            data = {
              signature_index = index,
            },
          })
        end

        break
      end
    end

    callback({
      items = items,
      isIncomplete = false,
    })
  end)
end

cmp.register_source("lsp_signature_list", signature_source.new())

local function open_signature_menu()
  if cmp.visible() then
    cmp.abort()
  end

  cmp.complete({
    config = {
      preselect = cmp.PreselectMode.None,

      sources = cmp.config.sources({
        { name = "lsp_signature_list" },
      }),

      sorting = {
        comparators = {
          function(entry1, entry2)
            if entry1.source.name == "lsp_signature_list"
                and entry2.source.name == "lsp_signature_list" then
              local index1 = entry1.completion_item.data.signature_index or 0
              local index2 = entry2.completion_item.data.signature_index or 0
              return index1 < index2
            end
          end,
        },
      },
    },
  })

  -- Select first item after cmp renders.
  vim.defer_fn(function()
    if cmp.visible() then
      cmp.select_next_item({
        behavior = cmp.SelectBehavior.Select,
      })
    end
  end, 30)
end

-- Diagnostic/error UI
vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = "always",
    border = "rounded",
    header = "",
    prefix = "",
  },
})

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  -- Do not preselect items globally.
  preselect = cmp.PreselectMode.None,

  window = {
    completion = cmp.config.window.bordered({
      side_padding = 1,
      scrollbar = true,
    }),
    documentation = cmp.config.window.bordered({
      max_height = 12,
      max_width = math.floor(vim.o.columns * 0.35),
    }),
  },

  formatting = {
    fields = { "abbr", "kind", "menu" },

    format = function(entry, vim_item)
      local item = entry:get_completion_item()

      local source_names = {
        nvim_lsp = "[LSP]",
        lsp_signature_list = "[sig]",
        luasnip = "[snippet]",
        buffer = "[buffer]",
        path = "[path]",
      }

      -- Signature entries:
      -- Full signature is shown in the main completion pane.
      if entry.source.name == "lsp_signature_list" then
        vim_item.abbr = truncate(item.label or vim_item.abbr, math.floor(vim.o.columns * 0.72))
        vim_item.kind = "[sig]"
        vim_item.menu = ""

        return vim_item
      end

      -- Normal autocomplete entries
      vim_item.kind = lspkind.symbolic(vim_item.kind, {
        mode = "symbol_text",
      })

      local detail =
        item.detail
        or (item.labelDetails and item.labelDetails.detail)
        or (item.labelDetails and item.labelDetails.description)
        or ""

      vim_item.abbr = truncate(vim_item.abbr, math.floor(vim.o.columns * 0.40))

      if detail ~= "" then
        vim_item.menu = truncate(detail, math.floor(vim.o.columns * 0.22))
      else
        vim_item.menu = source_names[entry.source.name] or ""
      end

      return vim_item
    end,
  },

  mapping = cmp.mapping.preset.insert({
    -- Normal autocomplete
    ["<C-Space>"] = cmp.mapping.complete(),

    -- Signature overload list.
    -- Opens from item 1 at the top.
    ["<C-l>"] = cmp.mapping(function()
      open_signature_menu()
    end, { "i", "s" }),

    -- Confirm selected completion item
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

    -- Move through completion/signature items
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

    -- Scroll documentation window
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),

    -- Close menu
    ["<C-e>"] = cmp.mapping.abort(),
  }),

  -- Normal autocomplete sources only.
  -- Signature overloads open ONLY with <C-l>.
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),

  experimental = {
    ghost_text = false,
  },
})

-- Formatting with conform.nvim
local ok_conform, conform = pcall(require, "conform")
if ok_conform then
  conform.setup({
    formatters_by_ft = {
      -- C / C++
      c = { "clang_format" },
      cpp = { "clang_format" },

      -- Rust
      rust = { "rustfmt" },

      -- JavaScript / TypeScript
      javascript = { "biome", "prettier", stop_after_first = true },
      javascriptreact = { "biome", "prettier", stop_after_first = true },
      typescript = { "biome", "prettier", stop_after_first = true },
      typescriptreact = { "biome", "prettier", stop_after_first = true },
      json = { "biome", "prettier", stop_after_first = true },
      jsonc = { "biome", "prettier", stop_after_first = true },
      css = { "biome", "prettier", stop_after_first = true },
      scss = { "prettier" },
      html = { "prettier" },
      markdown = { "prettier" },

      -- Go
      go = { "goimports", "gofumpt" },

      -- Ruby
      ruby = { "rubocop" },

      -- Elixir
      elixir = { "mix" },
      eelixir = { "mix" },
      heex = { "mix" },
    },

    format_on_save = {
      timeout_ms = 3000,
      lsp_format = "fallback",
    },
  })

  vim.keymap.set("n", "<leader>f", function()
    conform.format({
      async = true,
      lsp_format = "fallback",
    })
  end, { noremap = true, silent = true })
end

-- Linting with nvim-lint
local ok_lint, lint = pcall(require, "lint")
if ok_lint then
  lint.linters_by_ft = {
    -- JavaScript / TypeScript
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },

    -- Go
    go = { "golangcilint" },

    -- Ruby
    ruby = { "rubocop" },

    -- Elixir
    elixir = { "credo" },
  }

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    callback = function()
      lint.try_lint()
    end,
  })

  vim.keymap.set("n", "<leader>l", function()
    lint.try_lint()
  end, { noremap = true, silent = true })
end

-- C++ LSP: clangd
vim.lsp.config("clangd", {
  capabilities = capabilities,

  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
  },

  init_options = {
    fallbackFlags = {
      "-std=c++20",
    },
  },
})

vim.lsp.enable("clangd")

-- Other language servers
local servers = {
  -- Rust
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        check = {
          command = "clippy",
        },
      },
    },
  },

  -- JavaScript / TypeScript
  ts_ls = {},

  eslint = {},

  -- Go
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
      },
    },
  },

  -- Ruby
  ruby_lsp = {},

  -- Elixir
  elixirls = {},
}

for server_name, config in pairs(servers) do
  config.capabilities = capabilities
  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf, noremap = true, silent = true }

    -- Docs / type info
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    -- Navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

    -- Refactor / fixes
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    -- Diagnostics / errors
    vim.keymap.set("n", "<leader>d", function()
      vim.diagnostic.open_float(nil, {
        focus = false,
        scope = "cursor",
      })
    end, opts)

    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

    vim.keymap.set("n", "<leader>q", function()
      vim.diagnostic.setloclist()
    end, opts)
  end,
})
EOF
