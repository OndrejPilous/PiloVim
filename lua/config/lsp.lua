-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.
-- From vide: https://www.youtube.com/watch?v=tdhxpn1XdjQ&t=427s

-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
local lua_ls_opts = require("lsp.lua_ls") or {}
vim.lsp.config('lua_ls', lua_ls_opts)
vim.lsp.enable('lua_ls')

local typescript_opts = require("lsp.typescript")
vim.lsp.config('typescript', typescript_opts);
vim.lsp.enable('typescript', typescript_opts)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.opt.completeopt = { 'menu', 'menuone', 'fuzzy', 'popup', 'noselect', 'noinsert' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      -- reactivate autocompletion
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end, { buffer = ev.buf })

      -- Custom Esc to abort completion and revert to typed text
      vim.keymap.set('i', '<Esc>', function()
        if vim.fn.pumvisible() == 1 then
          -- Abort (<C-e>) and then exit insert mode (<Esc>)
          return vim.api.nvim_replace_termcodes('<C-e><Esc>', true, true, true)
        else
          -- Regular Esc if no menu
          return vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
        end
      end, { buffer = ev.buf, expr = true })

      -- Tab to select next item, Shift-Tab for previous
      vim.keymap.set('i', '<Tab>', function()
        if vim.fn.pumvisible() == 1 then -- Check if completion menu is visible
          return '<C-n>'                 -- Next item
        else
          return '<Tab>'                 -- Fallback to regular Tab (e.g., indent)
        end
      end, { buffer = ev.buf, expr = true })

      vim.keymap.set('i', '<S-Tab>', function()
        if vim.fn.pumvisible() == 1 then
          return '<C-p>'   -- Previous item
        else
          return '<S-Tab>' -- Fallback
        end
      end, { buffer = ev.buf, expr = true })

      -- Enter to confirm selection
      vim.keymap.set('i', '<CR>', function()
        if vim.fn.pumvisible() == 1 then
          return '<C-y>' -- Confirm
        else
          return '<CR>'
        end
      end, { buffer = ev.buf, expr = true })

      -- Keymap for formatting the buffer (e.g., <leader>df)
      vim.keymap.set('n', '<leader>cf', function()
        vim.lsp.buf.format({
          async = true,                                      -- Non-blocking for large files
          filter = function(c) return c.id == client.id end, -- Use only this LSP client
        })
      end, { buffer = ev.buf, desc = 'Format buffer with LSP' })
    end
  end,
})

-- Diagnostics
vim.diagnostic.config({
  -- Use the default configuration
  -- virtual_lines = true

  -- Alternatively, customize specific options
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = true
}
)
