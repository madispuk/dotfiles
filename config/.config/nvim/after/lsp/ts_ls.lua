-- Overrides on top of nvim-lspconfig's `lsp/ts_ls.lua`, which already provides
-- cmd, filetypes, lockfile-based root detection (so a monorepo gets one server
-- at the workspace root rather than one per package), Deno-conflict avoidance,
-- :LspTypescriptSourceAction, :LspTypescriptGoToSourceDefinition and the rename
-- handler for extract-function code actions.
--
-- The inlayHints settings below only take effect because LspAttach calls
-- vim.lsp.inlay_hint.enable(); toggle them at runtime with <leader>uh.
local inlay_hints = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

---@type vim.lsp.Config
return {
  settings = {
    typescript = {
      inlayHints = inlay_hints,
      preferences = { importModuleSpecifier = "relative" },
    },
    javascript = {
      inlayHints = inlay_hints,
      preferences = { importModuleSpecifier = "relative" },
    },
  },
}
