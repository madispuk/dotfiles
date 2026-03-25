local utils = require("utils")

local nmap = utils.nmap
local vmap = utils.vmap
local imap = utils.imap
local nnoremap = utils.nnoremap

-- ============================================================================
-- General Mappings
-- ============================================================================

-- Disable Ex mode
nnoremap("Q", "<nop>")
-- Disable Command-line window
vim.keymap.set("n", "q:", "<Nop>", { silent = true })

-- Quick escape from insert mode
imap("jk", "<Esc>", { desc = "escape" })

-- Quick save
nmap(",,", ":silent w<cr>", { desc = "save file" })

-- Clear search highlighting
nnoremap("<Esc>", ":noh<CR><CR>")

-- ============================================================================
-- Completion Navigation
-- ============================================================================

-- Smart completion navigation (use j/k to navigate popup menu)
vim.keymap.set("i", "<C-j>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true, replace_keycodes = true })

vim.keymap.set("i", "<C-k>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true, replace_keycodes = true })

-- ============================================================================
-- Visual Mode
-- ============================================================================

-- Keep visual selection when indenting
vmap("<", "<gv")
vmap(">", ">gv")

-- Repeat last command on visual selection
vmap(".", ":normal .<cr>")

-- ============================================================================
-- Navigation
-- ============================================================================

-- quick switch to alternate file
nmap("<leader>.", "<c-^>")

-- Window movement
nmap("<C-h>", "<C-w>h", { desc = "Move to left window" })
nmap("<C-j>", "<C-w>j", { desc = "Move to down window" })
nmap("<C-k>", "<C-w>k", { desc = "Move to up window" })
nmap("<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move through wrapped lines naturally
nnoremap("j", 'v:count == 0 ? "gj" : "j"', { expr = true })
nnoremap("k", 'v:count == 0 ? "gk" : "k"', { expr = true })
nnoremap("^", 'v:count == 0 ? "g^" :  "^"', { expr = true })
nnoremap("$", 'v:count == 0 ? "g$" : "$"', { expr = true })
