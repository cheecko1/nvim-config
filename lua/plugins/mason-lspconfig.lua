return{
		"williamboman/mason-lspconfig.nvim",
		config = function()
				require("mason-lspconfig").setup({
						ensure_installed = {
								'lua_ls',
								'arduino_language_server',
								'pyright',
						}
				})
		end,
}
