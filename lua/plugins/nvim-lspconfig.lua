return{
		"neovim/nvim-lspconfig",
		dependencies = {
				{"williamboman/mason.nvim", config = true},
		},
		config = function()
				--require('lspconfig').pyright.setup({})
				--require('lspconfig').rust_analyzer.setup({})
        vim.lsp.config.clangd = {
          cmd = {
            'clangd',
						"-fallback-style=webkit"
          },
				}
		end,
}
