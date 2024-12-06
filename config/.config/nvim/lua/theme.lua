local icons = {
  -- system icons
  linux = " ",
  macos = " ",
  windows = " ",
  -- diagnostic icons
  bug = "",
  -- error = "",
  -- error = "",
  error = " ",
  warning = " ",
  info = " ",
  -- hint = "",
  hint = "󰌶 ",
  -- lsp = " ",
  lsp = " ",
  line = "󰍜 ",
  -- git icons
  git = "",
  conflict = "",
  unstaged = "● ",
  staged = "✓ ",
  unmerged = " ",
  renamed = "➜ ",
  untracked = "? ",
  -- deleted = " ",
  ignored = "◌ ",
  modified = "● ",
  deleted = " ",
  added = " ",
  -- file icons
  arrow_closed = " ",
  arrow_open = " ",
  default = " ",
  open = " ",
  empty = " ",
  empty_open = " ",
  -- symlink = "",
  symlink_open = " ",
  file = " ",
  symlink = " ",
  file_readonly = " ",
  file_modified = " ",
  -- misc
  devil = " ",
  bsd = " ",
  ghost = " ",
}

local border = {
  { "🭽", "FloatBorder" },
  { "▔", "FloatBorder" },
  { "🭾", "FloatBorder" },
  { "▕", "FloatBorder" },
  { "🭿", "FloatBorder" },
  { "▁", "FloatBorder" },
  { "🭼", "FloatBorder" },
  { "▏", "FloatBorder" },
}

return { icons = icons, border = border }
