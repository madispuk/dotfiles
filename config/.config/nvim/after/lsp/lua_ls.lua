-- nvim-lspconfig's `lsp/lua_ls.lua` already sets cmd, filetypes, priority-ordered
-- root_markers and enables codeLens + inlay hints. Neovim runtime types come from
-- lazydev.nvim (see lua/plugins/core.lua), so no workspace.library setup here.
---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      diagnostics = { globals = { "vim" } },
    },
  },
}
