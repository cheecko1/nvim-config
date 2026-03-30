-- Global defaults for all LSP servers
local lsp_keymaps = vim.api.nvim_create_augroup('SamLspKeymaps', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_keymaps,
  callback = function(args)
    local bufnr = args.buf
    local bufmap = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Basic LSP keymaps
    bufmap('n', 'gd', vim.lsp.buf.definition, 'LSP: Go to definition')
    bufmap('n', 'gD', vim.lsp.buf.declaration, 'LSP: Go to declaration')
    bufmap('n', 'gi', vim.lsp.buf.implementation, 'LSP: Go to implementation')
    bufmap('n', 'gr', vim.lsp.buf.references, 'LSP: List references')
    bufmap('n', 'K', vim.lsp.buf.hover, 'LSP: Hover')
    bufmap('n', '<leader>rn', vim.lsp.buf.rename, 'LSP: Rename symbol')
    bufmap('n', '<leader>ca', vim.lsp.buf.code_action, 'LSP: Code action')
  end,
})

-- clangd configuration
vim.lsp.config('clangd', {
  cmd = {
		'clangd',
		'--compile-commands-dir=Debug',
		"-fallback-style=webkit",
    -- '--query-driver=/opt/ST/STM32CubeCLT_1.19.0/GNU-tools-for-STM32/bin/arm-none-eabi-*',
		},
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', '.git', '.clang-format', '.clangd' },
})

-- lua_ls configuration (Neovim config development)
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.enable({ 'clangd', 'lua_ls' })


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
