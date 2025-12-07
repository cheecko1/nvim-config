-- Global defaults for all LSP servers

local function lsp_on_attach(client, bufnr)
  local bufmap = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
  end

  print('LSP attached to buffer', bufnr)

  -- Basic LSP keymaps
  bufmap('n', 'gd', vim.lsp.buf.definition)
  bufmap('n', 'gD', vim.lsp.buf.declaration)
  bufmap('n', 'gi', vim.lsp.buf.implementation)
  bufmap('n', 'gr', vim.lsp.buf.references)
  bufmap('n', 'K',  vim.lsp.buf.hover)
  bufmap('n', '<leader>rn', vim.lsp.buf.rename)
  bufmap('n', '<leader>ca', vim.lsp.buf.code_action)
--[[
  -- Format buffer
  bufmap('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end) ]]
end

-- clangd configuration
vim.lsp.config('clangd', {
  cmd = {
		'clangd',
		'--compile-commands-dir=Debug',
		"-fallback-style=webkit"
		},
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', '.git' },
  on_attach = lsp_on_attach,
})

vim.lsp.enable({ 'clangd' })


-- Linting
vim.diagnostic.config({
  virtual_text = true,      -- inline messages (off by default in 0.11)
  signs = true,             -- gutter signs
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Global diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>fd', vim.diagnostic.open_float)
