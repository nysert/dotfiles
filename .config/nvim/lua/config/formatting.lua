local ok_conform, conform =
  pcall(require, "conform")

if not ok_conform then
  return
end

local function local_node_binary(ctx, name)
  local dir = ctx.dirname

  while dir and dir ~= "" do
    local candidate = vim.fs.joinpath(
      dir,
      "node_modules",
      ".bin",
      name
    )

    if vim.fn.executable(candidate) == 1 then
      return candidate
    end

    local parent = vim.fs.dirname(dir)

    if parent == dir then
      break
    end

    dir = parent
  end

  return nil
end

local function has_local_node_binary(name)
  return function(_, ctx)
    return local_node_binary(
      ctx,
      name
    ) ~= nil
  end
end

conform.setup({
  formatters = {
    biome = {
      condition =
        has_local_node_binary("biome"),
    },

    prettier = {
      condition =
        has_local_node_binary("prettier"),
    },

    rubocop = {
      inherit = false,
      command = "bundle",

      args = {
        "exec",
        "rubocop",
        "-a",
        "-f",
        "quiet",
        "--stderr",
        "--stdin",
        "$RELATIVE_FILEPATH",
      },

      stdin = true,

      cwd = require("conform.util").root_file({
        "Gemfile",
      }),

      require_cwd = true,

      exit_codes = {
        0,
        1,
      },
    },
  },

  formatters_by_ft = {
    c = {
      "clang_format",
    },

    cpp = {
      "clang_format",
    },

    rust = {
      "rustfmt",
    },

    javascript = {
      "biome",
      "prettier",
      stop_after_first = true,
    },

    javascriptreact = {
      "biome",
      "prettier",
      stop_after_first = true,
    },

    typescript = {
      "biome",
      "prettier",
      stop_after_first = true,
    },

    typescriptreact = {
      "biome",
      "prettier",
      stop_after_first = true,
    },

    json = {
      "biome",
      "prettier",
      stop_after_first = true,
    },

    jsonc = {
      "biome",
      "prettier",
      stop_after_first = true,
    },

    css = {
      "biome",
      "prettier",
      stop_after_first = true,
    },

    scss = {
      "prettier",
    },

    html = {
      "prettier",
    },

    markdown = {
      "prettier",
    },

    go = {
      "goimports",
      "gofumpt",
    },

    ruby = {
      "rubocop",
    },

    elixir = {
      "mix",
    },

    eelixir = {
      "mix",
    },

    heex = {
      "mix",
    },
  },

  format_on_save = {
    timeout_ms = 3000,
    lsp_format = "fallback",
  },
})

vim.keymap.set(
  "n",
  "<leader>f",
  function()
    conform.format({
      async = true,
      lsp_format = "fallback",
    })
  end,
  {
    noremap = true,
    silent = true,
  }
)
