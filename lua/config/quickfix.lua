-- Core
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>lo", ":lopen<CR>", { desc = "Open location list" })
vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "Close quickfix list" })
vim.keymap.set("n", "<leader>lc", ":lclose<CR>", { desc = "Close location list" })

vim.keymap.set("n", "]q", ":cn<CR>", { desc = "Next quickfix" })
vim.keymap.set("n", "[q", ":cp<CR>", { desc = "Previous quickfix" })
vim.keymap.set("n", "]l", ":lne<CR>", { desc = "Next location" })
vim.keymap.set("n", "[l", ":lp<CR>", { desc = "Previous location" })

-- LSP
vim.keymap.set('n', '<leader>ld', vim.diagnostic.setloclist, { desc = "Load diagnostics to location list" })

-- Todos
vim.keymap.set("n", "<leader>qt", ":TodoQuickFix<CR>", { desc = "Load todos to quickfix list" })
vim.keymap.set("n", "<leader>lt", ":TodoLocList<CR>", { desc = "Load todos to location list" })
