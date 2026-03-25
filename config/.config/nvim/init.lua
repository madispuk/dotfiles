-- ============================================================================
-- Leader Key (must be set before lazy.nvim)
-- ============================================================================
vim.g.mapleader = " "

-- ============================================================================
-- File Management
-- ============================================================================
vim.opt.backup = false -- don't use backup files
vim.opt.writebackup = false -- don't backup the file while editing
vim.opt.swapfile = false -- don't create swap files for new buffers
vim.opt.updatecount = 0 -- don't write swap files after some number of updates

-- ============================================================================
-- Editor Behavior
-- ============================================================================
vim.opt.history = 1000 -- store the last 1000 commands entered
vim.opt.textwidth = 120 -- after configured number of characters, wrap line
vim.opt.inccommand = "nosplit" -- show substitution results as they happen
vim.opt.clipboard = { "unnamed", "unnamedplus" } -- use the system clipboard
vim.opt.mouse = "a" -- enable mouse in all modes
vim.opt.exrc = true -- enable reading .nvimrc, .nvim.lua in current directory
vim.opt.secure = true -- restrict commands in local config files for security

-- ============================================================================
-- Search Settings
-- ============================================================================
vim.opt.ignorecase = true -- case insensitive searching
vim.opt.smartcase = true -- case-sensitive if expression contains a capital letter
vim.opt.hlsearch = true -- highlight search results
vim.opt.incsearch = true -- incremental search, like modern browsers

-- Use ripgrep for :grep if available
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --no-heading"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- ============================================================================
-- Timings and Feedback
-- ============================================================================
vim.opt.timeoutlen = 500 -- time to wait for mapped sequence to complete
vim.opt.updatetime = 300 -- faster completion and swap file writing

-- ============================================================================
-- UI and Appearance
-- ============================================================================
vim.o.termguicolors = true
vim.o.winborder = "rounded" -- rounded borders for floating windows

-- Line numbers and wrapping
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.wrap = true -- enable line wrapping
vim.opt.linebreak = true -- wrap at word boundaries
vim.opt.showbreak = "↪" -- character to show at the start of wrapped lines

-- Status and command line
vim.opt.laststatus = 3 -- global statusline
vim.opt.cmdheight = 1

-- Completion and wildmenu
vim.opt.wildmode = { "list", "longest" } -- complete files like a shell

-- Visual indicators
vim.opt.scrolloff = 7 -- keep 7 lines above/below cursor when scrolling
vim.opt.showmatch = true -- highlight matching brackets
vim.opt.signcolumn = "yes" -- always show sign column
vim.opt.title = true -- set terminal title

-- Special characters
vim.opt.list = true -- show invisible characters
vim.opt.listchars = {
  tab = "→ ",
  trail = "⋅",
  extends = "❯",
  precedes = "❮",
}
vim.opt.fcs = "eob: ,diff: " -- hide ~ on empty lines, hide dashes in diff filler

-- ============================================================================
-- Diagnostics
-- ============================================================================
vim.diagnostic.config({
  -- Show virtual text only for the most severe diagnostic per line
  virtual_text = {
    spacing = 4,
    prefix = "●",
  },
  -- Define diagnostic signs (modern way, not deprecated)
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌶",
    },
  },
  underline = false,
  update_in_insert = false,
  severity_sort = true, -- Most severe diagnostic appears first
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
})

-- ============================================================================
-- Indentation
-- ============================================================================
vim.opt.tabstop = 4 -- visual width of tabs
vim.opt.softtabstop = 4 -- edit as if tabs are 4 characters wide
vim.opt.shiftwidth = 4 -- number of spaces for indent and unindent
vim.opt.shiftround = true -- round indent to multiple of shiftwidth

-- ============================================================================
-- Plugin Manager (lazy.nvim)
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
})

-- ============================================================================
-- Keymaps
-- ============================================================================
require("keymaps")

-- ============================================================================
-- Colorscheme
-- ============================================================================
vim.cmd.colorscheme("catppuccin")
