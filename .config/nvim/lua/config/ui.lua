local nvim_tree = require("nvim-tree")
local nvim_tree_api = require("nvim-tree.api")

nvim_tree.setup({
  view = {
    number = true,
    relativenumber = true,
  },

  on_attach = function(bufnr)
    local opts = {
      buffer = bufnr,
      noremap = true,
      silent = true,
    }

    vim.keymap.set("n", "a", function()
      nvim_tree_api.fs.create()
    end, opts)

    vim.keymap.set("n", "d", function()
      nvim_tree_api.fs.remove()
    end, opts)

    vim.keymap.set("n", "r", function()
      nvim_tree_api.fs.rename()
    end, opts)

    vim.keymap.set("n", "m", function()
      nvim_tree_api.fs.cut()
    end, opts)

    vim.keymap.set("n", "p", function()
      nvim_tree_api.fs.paste()
    end, opts)

    vim.keymap.set("n", "x", function()
      nvim_tree_api.fs.copy()
    end, opts)

    vim.keymap.set("n", "<CR>", function()
      nvim_tree_api.node.open.edit()
    end, opts)

    vim.keymap.set("n", "s", function()
      nvim_tree_api.node.open.horizontal()
    end, opts)

    vim.keymap.set("n", "v", function()
      nvim_tree_api.node.open.vertical()
    end, opts)

    vim.keymap.set("n", "t", function()
      nvim_tree_api.node.open.tab()
    end, opts)

    vim.keymap.set("n", "T", function()
      local node = nvim_tree_api.tree.get_node_under_cursor()

      if not node then
        return
      end

      local curtab = vim.api.nvim_get_current_tabpage()

      vim.cmd("tabedit " .. vim.fn.fnameescape(node.absolute_path))
      vim.api.nvim_set_current_tabpage(curtab)
    end, opts)
  end,
})

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
