local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")
local lspkind = require("lspkind")

local M = {}

M.capabilities = cmp_lsp.default_capabilities()

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

  str = str:gsub("%*%*%*(.-)%*%*%*", "%1")
  str = str:gsub("%*%*(.-)%*%*", "%1")
  str = str:gsub("___(.-)___", "%1")
  str = str:gsub("__(.-)__", "%1")

  return str
end

local signature_source = {}

signature_source.new = function()
  return setmetatable({}, {
    __index = signature_source,
  })
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
    callback({
      items = {},
      isIncomplete = false,
    })

    return
  end

  local offset_encoding =
    clients[1].offset_encoding
    or "utf-16"

  local params =
    vim.lsp.util.make_position_params(
      0,
      offset_encoding
    )

  vim.lsp.buf_request_all(
    bufnr,
    "textDocument/signatureHelp",
    params,
    function(results)
      local items = {}

      for _, response in pairs(results) do
        local result = response.result

        if result and result.signatures then
          for index, sig in ipairs(result.signatures) do
            local label =
              clean_signature(sig.label or "")

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
    end
  )
end

cmp.register_source(
  "lsp_signature_list",
  signature_source.new()
)

local function open_signature_menu()
  if cmp.visible() then
    cmp.abort()
  end

  cmp.complete({
    config = {
      preselect = cmp.PreselectMode.None,

      sources = cmp.config.sources({
        {
          name = "lsp_signature_list",
        },
      }),

      sorting = {
        comparators = {
          function(entry1, entry2)
            if
              entry1.source.name == "lsp_signature_list"
              and entry2.source.name == "lsp_signature_list"
            then
              local index1 =
                entry1.completion_item.data.signature_index
                or 0

              local index2 =
                entry2.completion_item.data.signature_index
                or 0

              return index1 < index2
            end
          end,
        },
      },
    },
  })

  vim.defer_fn(function()
    if cmp.visible() then
      cmp.select_next_item({
        behavior = cmp.SelectBehavior.Select,
      })
    end
  end, 30)
end

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  preselect = cmp.PreselectMode.None,

  window = {
    completion = cmp.config.window.bordered({
      side_padding = 1,
      scrollbar = true,
    }),

    documentation = cmp.config.window.bordered({
      max_height = 12,
      max_width = math.floor(
        vim.o.columns * 0.35
      ),
    }),
  },

  formatting = {
    fields = {
      "abbr",
      "kind",
      "menu",
    },

    format = function(entry, vim_item)
      local item =
        entry:get_completion_item()

      local source_names = {
        nvim_lsp = "[LSP]",
        lsp_signature_list = "[sig]",
        luasnip = "[snippet]",
        buffer = "[buffer]",
        path = "[path]",
      }

      if entry.source.name == "lsp_signature_list" then
        vim_item.abbr = truncate(
          item.label or vim_item.abbr,
          math.floor(vim.o.columns * 0.72)
        )

        vim_item.kind = "[sig]"
        vim_item.menu = ""

        return vim_item
      end

      vim_item.kind = lspkind.symbolic(
        vim_item.kind,
        {
          mode = "symbol_text",
        }
      )

      local detail =
        item.detail
        or (
          item.labelDetails
          and item.labelDetails.detail
        )
        or (
          item.labelDetails
          and item.labelDetails.description
        )
        or ""

      vim_item.abbr = truncate(
        vim_item.abbr,
        math.floor(vim.o.columns * 0.40)
      )

      if detail ~= "" then
        vim_item.menu = truncate(
          detail,
          math.floor(vim.o.columns * 0.22)
        )
      else
        vim_item.menu =
          source_names[entry.source.name]
          or ""
      end

      return vim_item
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),

    ["<C-l>"] = cmp.mapping(function()
      open_signature_menu()
    end, {
      "i",
      "s",
    }),

    ["<CR>"] = cmp.mapping.confirm({
      select = true,
    }),

    ["<C-j>"] =
      cmp.mapping.select_next_item({
        behavior = cmp.SelectBehavior.Select,
      }),

    ["<C-k>"] =
      cmp.mapping.select_prev_item({
        behavior = cmp.SelectBehavior.Select,
      }),

    ["<C-d>"] =
      cmp.mapping.scroll_docs(4),

    ["<C-u>"] =
      cmp.mapping.scroll_docs(-4),

    ["<C-e>"] =
      cmp.mapping.abort(),
  }),

  sources = cmp.config.sources({
    {
      name = "nvim_lsp",
    },

    {
      name = "luasnip",
    },

    {
      name = "buffer",
    },

    {
      name = "path",
    },
  }),

  experimental = {
    ghost_text = false,
  },
})

return M
