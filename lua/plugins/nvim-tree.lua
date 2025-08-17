return {
		"nvim-tree/nvim-tree.lua",
		config = function()
				require("nvim-tree").setup({
						filters = {
								dotfiles = false,
						},
						disable_netrw = true,
						hijack_netrw = true,
				})
		end,
}
