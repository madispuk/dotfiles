-- ruff acts as linter / import-sorter / quick-fix source only; basedpyright owns
-- hover and completion. Settings are intentionally not pinned here so ruff
-- discovers them per-file (ruff.toml, .ruff.toml or [tool.ruff] in pyproject.toml)
-- -- pinning lineLength client-side would disagree with the ruff CLI that conform
-- runs on save.
---@type vim.lsp.Config
return {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
