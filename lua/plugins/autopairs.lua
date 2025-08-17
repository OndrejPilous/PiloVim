return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({
      check_ts = true,           -- Enable Treesitter integration (smart pairs in .vue, .js, etc)
      ts_config = {
        javascript = { "template_string" }, -- Adjust based on your needs
        javascriptreact = { "template_string" },
        typescript = { "template_string" },
        typescriptreact = { "template_string" },
        vue = { "template_string" },
      },
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "spectre_panel" }, -- Exclude unneeded filetypes
      map_bs = true,           -- Allow backspace to delete pairs smartly
      map_cr = true,           -- Smart <CR> (Enter) on paired lines
      enable_afterquote = true,
      enable_check_bracket_line = true,
    })
  end,
}

