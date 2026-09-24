local ok_lint, lint =
  pcall(require, "lint")

if not ok_lint then
  return
end

local function ruby_project_root(bufnr)
  local filename =
    vim.api.nvim_buf_get_name(bufnr)

  local start_path =
    filename ~= ""
    and vim.fs.dirname(filename)
    or vim.fn.getcwd()

  local gemfile = vim.fs.find(
    "Gemfile",
    {
      upward = true,
      path = start_path,
    }
  )[1]

  return
    gemfile
    and vim.fs.dirname(gemfile)
    or nil
end

local node_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local eslint_config_names = {
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yml",
  ".eslintrc.yaml",
}

local biome_config_names = {
  "biome.json",
  "biome.jsonc",
  ".biome.json",
  ".biome.jsonc",
}

local function find_project_file(
  bufnr,
  names
)
  local filename =
    vim.api.nvim_buf_get_name(bufnr)

  local start_path =
    filename ~= ""
    and vim.fs.dirname(filename)
    or vim.fn.getcwd()

  return vim.fs.find(
    names,
    {
      upward = true,
      path = start_path,
    }
  )[1]
end

local function node_binary_root(
  bufnr,
  name
)
  local filename =
    vim.api.nvim_buf_get_name(bufnr)

  local dir =
    filename ~= ""
    and vim.fs.dirname(filename)
    or vim.fn.getcwd()

  while dir and dir ~= "" do
    local binary = vim.fs.joinpath(
      dir,
      "node_modules",
      ".bin",
      name
    )

    if vim.fn.executable(binary) == 1 then
      return dir
    end

    local parent = vim.fs.dirname(dir)

    if parent == dir then
      break
    end

    dir = parent
  end

  return nil
end

local function node_project_linter(bufnr)
  if find_project_file(
    bufnr,
    eslint_config_names
  ) then
    local cwd =
      node_binary_root(
        bufnr,
        "eslint"
      )

    if cwd then
      return "eslint", cwd
    end
  end

  if find_project_file(
    bufnr,
    biome_config_names
  ) then
    local cwd =
      node_binary_root(
        bufnr,
        "biome"
      )

    if cwd then
      return "biomejs", cwd
    end
  end

  return nil, nil
end

local rubocop = lint.linters.rubocop

rubocop.cmd = "bundle"

rubocop.args = {
  "exec",
  "rubocop",
  "--format",
  "json",
  "--force-exclusion",
  "--stdin",

  function()
    local bufnr =
      vim.api.nvim_get_current_buf()

    local filename =
      vim.api.nvim_buf_get_name(bufnr)

    local root =
      ruby_project_root(bufnr)

    return
      root
      and vim.fs.relpath(
        root,
        filename
      )
      or filename
  end,
}

local biomejs = lint.linters.biomejs

biomejs.args = {
  "lint",

  function()
    return vim.api.nvim_buf_get_name(0)
  end,
}

lint.linters_by_ft = {
  go = {
    "golangcilint",
  },

  ruby = {
    "rubocop",
  },

  elixir = {
    "credo",
  },
}

local function run_linter(bufnr)
  if vim.bo[bufnr].filetype == "ruby" then
    local cwd =
      ruby_project_root(bufnr)

    if cwd then
      lint.try_lint(
        nil,
        {
          cwd = cwd,
        }
      )
    end

    return
  end

  if node_filetypes[
    vim.bo[bufnr].filetype
  ] then
    local linter, cwd =
      node_project_linter(bufnr)

    if linter and cwd then
      lint.try_lint(
        linter,
        {
          cwd = cwd,
        }
      )
    end

    return
  end

  lint.try_lint()
end

vim.api.nvim_create_autocmd(
  {
    "BufWritePost",
    "BufEnter",
  },
  {
    callback = function(args)
      run_linter(args.buf)
    end,
  }
)

vim.keymap.set(
  "n",
  "<leader>l",
  function()
    run_linter(
      vim.api.nvim_get_current_buf()
    )
  end,
  {
    noremap = true,
    silent = true,
  }
)
