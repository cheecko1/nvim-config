return {
		"williamboman/mason.nvim",
		config = function()
				require("mason").setup({
						-- manages all external tools
						ensure_installed={
								'pylint',
								'clangd',
						}
				})
		end,
}
