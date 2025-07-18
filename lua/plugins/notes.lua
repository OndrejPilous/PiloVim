-- plugins/todo-comments.lua

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },  -- Required for search/jump features
  event = "BufReadPre",  -- Lazy load on buffer read for fast startup
  opts = {
    signs = true,  -- Show edgy icons in the signs column
    sign_priority = 8,  -- Keep priority to avoid overriding diagnostics
    -- Keywords with punk/rebel twists: Added custom ones like "REBEL" for soviet flair
    keywords = {
      FIX = {
        icon = "󰯆 ",  -- nf-fa-skull_crossbones (punk death/fix vibe)
        color = "error",
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
      },
      TODO = {
        icon = " ",  -- Checkmark, but we'll color it boldly
        color = "info",
      },
      HACK = {
        icon = " ", 
        color = "warning",
      },
      WARN = {
        icon = " ",  -- Warning triangle, kept for familiarity
        color = "warning",
        alt = { "WARNING", "XXX" },
      },
      PERF = {
        icon = "󰓅 ",  -- Clock for optimization
        alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
      },
      NOTE = {
        icon = "󰋼 ",  -- Info bulb
        color = "hint",
        alt = { "INFO" },
      },
      TEST = {
        icon = "󰙨 ",  -- Timer for tests
        color = "test",
        alt = { "TESTING", "PASSED", "FAILED" },
      },
    },
    gui_style = {
      fg = "ITALIC",  -- Italic foreground for a handwritten, graffiti punk feel
      bg = "BOLD",    -- Bold background to make todos pop like street art
    },
    merge_keywords = true,  -- Merge customs with defaults for full coverage
    -- Highlighting: Wide and gritty for that underground depth
    highlight = {
      multiline = true,  -- Support multiline todos (great for Vue components)
      multiline_pattern = "^.",  -- Match next lines flexibly
      multiline_context = 10,   -- Re-evaluate generously for edits
      before = "fg",            -- Subtle foreground before keyword (e.g., comment chars)
      keyword = "wide_bg",      -- Wide background highlight for surrounding grit
      after = "fg",             -- Foreground after for readable todo text
      pattern = [[.*<(KEYWORDS)\s*:]],  -- Vim regex for precise matching
      comments_only = true,     -- Treesitter magic: Only in comments (Vue-friendly)
      max_line_len = 800,       -- Bump up for longer lines in FE code
      exclude = { "help", "man" },  -- Skip non-code files
    },
    -- Colors: Dark punk palette with rose-pine-inspired reds/grays for rebel energy
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#C94F6D" },    -- Bold red (soviet punch)
      warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },  -- Yellow warning
      info = { "DiagnosticInfo", "#908CAA" },                   -- Muted purple-gray (underground)
      hint = { "DiagnosticHint", "#10B981" },                   -- Green hint
      default = { "Identifier", "#7C3AED" },                    -- Purple default
      test = { "Identifier", "#EB6F92" },                       -- Pink-red for tests (punk energy)
    },
    -- Search: Enhanced ripgrep for quick todo jumps, with punk-style filtering
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--hidden",  -- Include hidden files for underground discoveries
      },
      pattern = [[\b(KEYWORDS):]],  -- Ripgrep regex with colon for accuracy
    },
  },
}

