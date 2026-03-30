vim.lsp.config("pyright", {
  settings = {
    python = {
      venvPath = ".",
      venv = ".venv",
			pythonPath = ".venv/bin/python",
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

