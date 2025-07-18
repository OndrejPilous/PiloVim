-- plugins/colorizer.lua
-- High-performance color highlighter for FE dev (now with Vue support!)

return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",  -- Lazy load on buffer read for fast startup
  opts = {
    filetypes = {
      "css",        -- Core for stylesheets
      "scss",       -- Sass support
      "html",       -- HTML markup
      "javascript", -- JS/TS (pairs well with React/Vue)
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "vue",        -- Added for Vue SFC highlighting
      "*",          -- Fallback for other files, like config or Markdown
    },
    user_default_options = {
      RGB = true,       -- #RGB hex codes
      RRGGBB = true,    -- #RRGGBB hex codes
      names = true,     -- Color names like "blue" or "red"
      RRGGBBAA = true,  -- #RRGGBBAA hex codes
      rgb_fn = true,    -- CSS rgb() functions
      hsl_fn = true,    -- CSS hsl() functions
      css = true,       -- Enable all CSS features
      tailwind = "both",-- Tailwind colors via LSP and built-in (perfect for Vue apps)
      mode = "background",  -- Highlight as background for subtle, underground integration
      always_update = true, -- Update colors even in unfocused buffers (e.g., Vue previews)
    },
    -- Optional: Enable user commands for toggling
    user_commands = true,
  },
}

