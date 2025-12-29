vim.lsp.config("pyright", {
  settings = {
    python = {
      venvPath = ".",
      venv = ".venv",
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

