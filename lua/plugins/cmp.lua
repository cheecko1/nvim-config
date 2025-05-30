return{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
				"hrsh7th/cmp-buffer",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				"rafamadriz/friendly-snippets",
				"onsails/lspkind.nvim",
		},
		config = function()
				local cmp = require("cmp")
				
				local luasnip = require("luasnip")

				local lspkind = require("lspkind")

				require("luasnip.loaders.from_vscode").lazy_load()

				cmp.setup({
						completion = {
								completopt = "menu,menuone,preview,noselect",
						},
						snippet = {
								expand = function(args)
										luasnip.lsp_expand(args.body)
								end,
						},
						mapping = cmp.mapping.preset.insert({
								["<C-p>"] = cmp.mapping.select_prev_item(),
								["<C-n>"] = cmp.mapping.select_next_item(),
								["<C-u>"] = cmp.mapping.scroll_docs(-4),
								["<C-d>"] = cmp.mapping.scroll_docs(4),
								["<C-Space>"] = cmp.mapping.complete(),
								["<C-e>"] = cmp.mapping.abort(),
								["<CR>"] = cmp.mapping.confirm({ select = false }),
						}),

						sources = cmp.config.sources({
								{ name = "nvim_lsp" },
								{ name = "luasnip" },
								{ name = "buffer" },
								{ name = "path" },
						}),

						formatting = {
								format = lspkind.cmp_format({
										maxwidth = 50,
										ellipsis_char = "...",
								}),
						},
				})
		end,
}
