local capabilities =
  require("config.completion").capabilities

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

local servers = {
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

  ts_ls = {
    cmd = function(
      dispatchers,
      config
    )
      local root =
        (config or {}).root_dir

      if root then
        local local_tsc =
          vim.fs.joinpath(
            root,
            "node_modules",
            ".bin",
            "tsc"
          )

        local local_tsserver =
          vim.fs.joinpath(
            root,
            "node_modules",
            "typescript",
            "lib",
            "tsserver.js"
          )

        if
          vim.fn.executable(local_tsc) == 1
          and vim.fn.filereadable(
            local_tsserver
          ) == 0
        then
          return vim.lsp.rpc.start(
            {
              local_tsc,
              "--lsp",
              "--stdio",
            },
            dispatchers
          )
        end
      end

      local cmd =
        "typescript-language-server"

      if root then
        local local_cmd =
          vim.fs.joinpath(
            root,
            "node_modules",
            ".bin",
            cmd
          )

        if vim.fn.executable(local_cmd) == 1 then
          cmd = local_cmd
        end
      end

      return vim.lsp.rpc.start(
        {
          cmd,
          "--stdio",
        },
        dispatchers
      )
    end,
  },

  -- ESLint diagnostics intentionally come from nvim-lint using the
  -- project's local node_modules/.bin/eslint.

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

  ruby_lsp = {
    init_options = {
      formatter = "none",
      linters = {},

      enabledFeatures = {
        diagnostics = false,
        formatting = false,
        codeActions = false,
      },
    },
  },

  elixirls = {},
}

for server_name, config in pairs(servers) do
  config.capabilities = capabilities

  vim.lsp.config(
    server_name,
    config
  )

  vim.lsp.enable(server_name)
end

vim.api.nvim_create_autocmd(
  "LspAttach",
  {
    callback = function(event)
      local opts = {
        buffer = event.buf,
        noremap = true,
        silent = true,
      }

      vim.keymap.set(
        "n",
        "K",
        vim.lsp.buf.hover,
        opts
      )

      vim.keymap.set(
        "n",
        "gd",
        vim.lsp.buf.definition,
        opts
      )

      vim.keymap.set(
        "n",
        "gD",
        vim.lsp.buf.declaration,
        opts
      )

      vim.keymap.set(
        "n",
        "gi",
        vim.lsp.buf.implementation,
        opts
      )

      vim.keymap.set(
        "n",
        "gr",
        vim.lsp.buf.references,
        opts
      )

      vim.keymap.set(
        "n",
        "gt",
        vim.lsp.buf.type_definition,
        opts
      )

      vim.keymap.set(
        "n",
        "<leader>rn",
        vim.lsp.buf.rename,
        opts
      )

      vim.keymap.set(
        "n",
        "<leader>ca",
        vim.lsp.buf.code_action,
        opts
      )

      vim.keymap.set(
        "n",
        "<leader>d",
        function()
          vim.diagnostic.open_float(
            nil,
            {
              focus = false,
              scope = "cursor",
            }
          )
        end,
        opts
      )

      vim.keymap.set(
        "n",
        "[d",
        vim.diagnostic.goto_prev,
        opts
      )

      vim.keymap.set(
        "n",
        "]d",
        vim.diagnostic.goto_next,
        opts
      )

      vim.keymap.set(
        "n",
        "<leader>q",
        function()
          vim.diagnostic.setloclist()
        end,
        opts
      )
    end,
  }
)
