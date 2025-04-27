return{
		"neovim/nvim-lspconfig",
		dependencies = {
				{"williamboman/mason.nvim", config = true},
		},
		config = function()
				require('lspconfig').pyright.setup({})
		end,
}
