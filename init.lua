require "config.lazy"
-- Auto update
vim.api.nvim_create_autocmd("VimEnter",{callback=function()require"lazy".update({show = false})end})
require "sam.remap"
require "sam.options"
require "config.lsp"
require "config.todo-comments"
require "config.quickfix"
require "config.pyright"
require	"ftdetect.pio"
--vim.cmd "colorscheme catppuccin"
vim.cmd "colorscheme edge"
