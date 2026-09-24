require("mason").setup()

require("mason-lspconfig").setup({
  automatic_enable = false,

  ensure_installed = {
    "clangd",
    "rust_analyzer",
    "ts_ls",
    "gopls",
    "ruby_lsp",
    "elixirls",
  },
})

local ok_mason_tools, mason_tool_installer = pcall(
  require,
  "mason-tool-installer"
)

if ok_mason_tools then
  mason_tool_installer.setup({
    ensure_installed = {
      "clang-format",

      -- JavaScript / TypeScript formatter/linter binaries deliberately
      -- come from the current project's node_modules/.bin.

      "goimports",
      "gofumpt",
      "golangci-lint",

      -- Ruby formatting/linting uses bundle exec rubocop.
    },
  })
end
