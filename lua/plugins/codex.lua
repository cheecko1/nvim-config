return {
  'kkrampis/codex.nvim',
  lazy = true,
  cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
  keys = {
    {
      '<leader>cx', -- Change this to your preferred keybinding
      function() require('codex').toggle() end,
      desc = 'Toggle Codex popup or side-panel',
      mode = { 'n', 't' }
    },
  },
  config = function(_, opts)
    local codex = require('codex')
    codex.setup(opts)

    -- codex.nvim's built-in panel mode sizes as a percentage of `vim.o.columns` and
    -- may reshuffle other splits. Patch its internal `open_panel()` so it always:
    -- - splits the *current* window
    -- - sizes the Codex panel as a fraction of the current window width
    if not (opts.panel and type(opts.width) == 'number') then return end
    if not (type(debug) == 'table' and type(debug.getupvalue) == 'function' and type(debug.setupvalue) == 'function') then return end

    local panel_width_factor = opts.width

    local function open_panel_split_current()
      local state = require('codex.state')

      local original_win = vim.api.nvim_get_current_win()
      local original_width = vim.api.nvim_win_get_width(original_win)
      local old_equalalways = vim.o.equalalways
      local had_winfixwidth = vim.wo[original_win].winfixwidth
      vim.o.equalalways = false
      vim.wo[original_win].winfixwidth = false

      local ok, err = pcall(function()
        vim.cmd('silent! noautocmd vertical rightbelow vsplit')
        local panel_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(panel_win, state.buf)
        vim.api.nvim_win_set_width(
          panel_win,
          math.min(math.max(1, math.floor(original_width * panel_width_factor)), math.max(1, original_width - 1))
        )
        pcall(vim.api.nvim_win_set_width, original_win, original_width - vim.api.nvim_win_get_width(panel_win))

        state.win = panel_win
      end)

      vim.o.equalalways = old_equalalways

      if had_winfixwidth and vim.api.nvim_win_is_valid(original_win) then
        vim.wo[original_win].winfixwidth = true
      end

      if not ok then error(err) end
    end

    for i = 1, 50 do
      local name = debug.getupvalue(codex.open, i)
      if not name then break end
      if name == 'open_panel' then
        debug.setupvalue(codex.open, i, open_panel_split_current)
        break
      end
    end
  end,
  opts = {
    keymaps     = {
      toggle = nil, -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
      quit = '<C-q>', -- Keybind to close the Codex window (default: Ctrl + q)
    },         -- Disable internal default keymap (<leader>cc -> :CodexToggle)
    border      = 'rounded',  -- Options: 'single', 'double', or 'rounded'
    width       = 0.5,        -- Width of the floating window (0.0 to 1.0)
    height      = 0.8,        -- Height of the floating window (0.0 to 1.0)
    model       = nil,        -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
    autoinstall = true,       -- Automatically install the Codex CLI if not found
    panel       = true,      -- Open Codex in a side-panel (vertical split) instead of floating window
    use_buffer  = false,      -- Capture Codex stdout into a normal buffer instead of a terminal buffer
  },
}
