return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		local ns = require("lint").get_namespace("pylint")
		--vim.diagnostic.config({ virtual_text = false}, ns)

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>ll", function()
			--vim.diagnostic.config({ virtual_text = true}, ns)
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
		--[[
				vim.keymap.set("n", "<leader>lh", function()
						vim.diagnostic.config({virtual_text = false})
				end, { desc = "Turn off virtual text"})


				vim.keymap.set("n", "<leader>lc", function()
						vim.diagnostic.config({virtual_text = true})
				end, { desc = "Turn on virtual text"})
		]]
		vim.keymap.set("n", "<leader>lt", function()
			local current = vim.diagnostic.config().virtual_text
			vim.diagnostic.config({ virtual_text = not current })
			vim.notify("Virtual text " .. (not current and "enabled" or "disabled"))
		end, { desc = "Toggle virtual text" })
	end,
}
