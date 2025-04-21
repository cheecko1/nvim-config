return {
		"nvim-tree/nvim-tree.lua",
		config = function()
				require("nvim-tree").setup({
						filters = {
								dotfiles = true,
						},
						disable_netrw = true,
						hijack_netrw = true,
				})
		end,
}
