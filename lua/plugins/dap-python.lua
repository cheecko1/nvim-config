-- lua/plugins/dap-python.lua
return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap_python = require("dap-python")

      -- Path to python inside the project venv
      local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"

      if vim.fn.executable(venv_path) == 1 then
        dap_python.setup(venv_path)
      else
        -- Fallback (optional): system python or a tools venv
        dap_python.setup("python")
        vim.notify(
          "nvim-dap-python: .venv not found, using system python",
          vim.log.levels.WARN
        )
      end
    end,
  },
}

