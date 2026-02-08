return{
		"williamboman/mason-lspconfig.nvim",
		config = function()
				require("mason-lspconfig").setup({
						-- manages LSP servers
						ensure_installed = {
								'lua_ls',
								'arduino_language_server',
								'pyright',
								'ts_ls',
						}
				})
		end,
}
