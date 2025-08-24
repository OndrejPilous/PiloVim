return {
  "hrsh7th/nvim-cmp",           -- Completion plugin
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",    -- LSP source for nvim-cmp
    "hrsh7th/cmp-buffer",      -- Buffer completions
    "hrsh7th/cmp-path",        -- Path completions
    "saadparwaiz1/cmp_luasnip",-- Snippet completions
    "L3MON4D3/LuaSnip",        -- Snippet engine
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),    -- manual trigger
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm with enter
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
      }),
      completion = {
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },  -- Popup automatically while typing
      },
      experimental = {
        ghost_text = true,  -- Show inline ghost text preview
      },
    })

  end,
}

