return {
  cmd = { "typescript-language-server", "--stdio" },  -- Assumes it's in PATH
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", ".git" }),  -- Detect project root
  settings = {
    typescript = {
      inlayHints = {  -- Optional: Enable inlay hints
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
      },
    },
    javascript = {
      inlayHints = {  -- Same for JS
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
      },
    },
  },
}

