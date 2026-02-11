-- nvim v0.8.0
return {
    "kdheepak/lazygit.nvim",
    lazy = true,
    -- init = function()
    --     local sam_lazygit_overrides = vim.api.nvim_create_augroup("SamLazyGitOverrides", { clear = true })
    --
    --     local function clear_lazygit_qj(buf)
    --         pcall(vim.keymap.del, "t", "qj", { buffer = buf })
    --     end
    --
    --     vim.api.nvim_create_autocmd("FileType", {
    --         group = sam_lazygit_overrides,
    --         pattern = "lazygit",
    --         callback = function(ev)
    --             clear_lazygit_qj(ev.buf) -- removes qj keymap in lazygit window
    --         end,
    --     })
    --
    --     vim.api.nvim_create_autocmd("TermOpen", {
    --         group = sam_lazygit_overrides,
    --         pattern = "*",
    --         callback = function(ev)
    --             local buf = ev.buf
    --             vim.schedule(function()
    --                 if not vim.api.nvim_buf_is_valid(buf) then
    --                     return
    --                 end
    --
    --                 local ft = vim.bo[buf].filetype
    --                 local name = vim.api.nvim_buf_get_name(buf)
    --                 if ft == "lazygit" or name:match("lazygit") then
    --                     clear_lazygit_qj(buf)
    --                 end
    --             end)
    --         end,
    --     })
    -- end,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
}
