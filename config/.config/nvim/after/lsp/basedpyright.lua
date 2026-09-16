-- Overrides on top of nvim-lspconfig's `lsp/basedpyright.lua` (which supplies cmd,
-- root_markers incl. pyrightconfig.json, autoSearchPaths, diagnosticMode =
-- "openFilesOnly" and the :LspPyrightOrganizeImports / :LspPyrightSetPythonPath
-- commands -- so do not define on_attach here, it would replace theirs).
--
-- Imports are handled by ruff (conform runs ruff_organize_imports on save), hence
-- disableOrganizeImports. `useLibraryCodeForTypes` is deliberately unset: upstream
-- discourages it because a client-side value overrides per-project pyproject.toml.
---@type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        typeCheckingMode = "standard",
        autoImportCompletions = true,
        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
          functionReturnTypes = true,
          genericTypes = false,
        },
      },
    },
  },
}
