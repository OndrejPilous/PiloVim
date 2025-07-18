-- lualine.lua
-- Custom status line with rose-pine dark colors

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "rose-pine/neovim" },  -- Add rose-pine dependency
  event = "VeryLazy",
  config = function()
    -- Custom Lualine component to show attached language server (unchanged)
    local clients_lsp = function()
      local bufnr = vim.api.nvim_get_current_buf()

      local clients = vim.lsp.get_clients()
      if next(clients) == nil then
        return ""
      end

      local c = {}
      for _, client in pairs(clients) do
        table.insert(c, client.name)
      end
      return " " .. table.concat(c, "|")
    end

    -- Define custom theme using Rose-Pine Moon colors manually for dark, underground vibe
    local custom_rose_pine = {
      normal = {
        a = { fg = "#232136", bg = "#eb6f92" },  -- Pink-red for punk energy
        b = { fg = "#e0def4", bg = "#393552" },
        c = { fg = "#908caa", bg = "#1f1d2e" },  -- Deep gray for gritty feel
      },
      insert = { a = { fg = "#232136", bg = "#9ccfd8" } },  -- Teal insert
      visual = { a = { fg = "#232136", bg = "#f6c177" } },  -- Gold visual (soviet nod)
      replace = { a = { fg = "#232136", bg = "#eb6f92" } },
      command = { a = { fg = "#232136", bg = "#c4a7e7" } },
      inactive = {
        a = { fg = "#908caa", bg = "#191724" },  -- Blackish inactive for underground depth
        b = { fg = "#908caa", bg = "#191724" },
        c = { fg = "#908caa", bg = "#191724" },
      },
    }

    -- Custom overrides for rebel accents (from earlier tweaks)
    custom_rose_pine.normal.a.bg = "#c94f6d"  -- Bold red for active mode
    custom_rose_pine.normal.b.fg = "#cad3f5"  -- Light foreground for contrast
    custom_rose_pine.normal.c.fg = "#6e738d"  -- Muted text
    custom_rose_pine.normal.c.bg = "#1e2030"  -- Dark background

    require("lualine").setup({
      options = {
        theme = custom_rose_pine,
        component_separators = "",
        section_separators = { left = "", right = "" },  -- Rounded for nicer blending
        disabled_filetypes = { "alpha", "Outline" },
        icons_enabled = true,  -- Enable for your existing icons
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = "", right = "" }, icon = "" },  -- Kept original icon
        },
        lualine_b = {
          {
            "filetype",
            icon_only = true,
            padding = { left = 1, right = 0 },
          },
          "filename",
        },
        lualine_c = {
          {
            "branch",
            icon = "",  -- Kept original (the "fish" suspect? :D)
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },  -- Kept originals
            colored = false,
          },
        },
        lualine_x = {
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = " " },  -- Kept originals
            update_in_insert = true,
          },
        },
        lualine_y = { clients_lsp },
        lualine_z = {
          { "location", separator = { left = "", right = " " }, icon = "" },  -- Kept original icon
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      extensions = { "toggleterm", "trouble" },
    })
  end,
}

