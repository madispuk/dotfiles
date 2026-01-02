require("globals")
local utils = require("utils")
local icons = require("theme").icons

local termcodes = utils.termcodes
local nmap = utils.nmap
local vmap = utils.vmap
local imap = utils.imap
local nnoremap = utils.nnoremap
local inoremap = utils.inoremap

-- create a completion_nvim table on _G which is visible via
-- v:lua from vimscript
_G.completion_nvim = {}

function _G.completion_nvim.smart_pumvisible(vis_seq, not_vis_seq)
  if vim.fn.pumvisible() == 1 then
    return termcodes(vis_seq)
  else
    return termcodes(not_vis_seq)
  end
end

-- General
----------------------------------------------------------------

vim.opt.backup = false -- don't use backup files
vim.opt.writebackup = false -- don't backup the file while editing
vim.opt.swapfile = false -- don't create swap files for new buffers
vim.opt.updatecount = 0 -- don't write swap files after some number of updates

vim.opt.backupdir = { "~/.vim-tmp", "~/.tmp", "~/tmp", "/var/tmp", "/tmp" }
vim.opt.directory = { "~/.vim-tmp", "~/.tmp", "~/tmp", "/var/tmp", "/tmp" }

vim.opt.history = 1000 -- store the last 1000 commands entered
vim.opt.textwidth = 120 -- after configured number of characters, wrap line

-- show the results of substition as they're happening but don't open a split
vim.opt.inccommand = "nosplit"

vim.opt.backspace = { "indent", "eol", "start" } -- make backspace behave in a sane manner
vim.opt.clipboard = { "unnamed", "unnamedplus" } -- use the system clipboard
vim.opt.mouse = "a" -- set mouse mode to all modes

-- searching
vim.opt.ignorecase = true -- case insensitive searching
vim.opt.smartcase = true -- case-sensitive if expresson contains a capital letter
vim.opt.hlsearch = true -- highlight search results
vim.opt.incsearch = true -- set incremental search, like modern browsers
vim.opt.lazyredraw = false -- don't redraw while executing macros
vim.opt.magic = true -- set magic on, for regular expressions

if vim.fn.executable("rg") then
  -- if ripgrep installed, use that as a grepper
  vim.opt.grepprg = "rg --vimgrep --no-heading"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
  -- create autocmd to automatically open quickfix window when grepping
  vim.cmd([[autocmd QuickFixCmdPost [^l]* nested cwindow]])
end

-- error bells
vim.opt.errorbells = false
vim.opt.visualbell = true
vim.opt.timeoutlen = 500

-- Appearance
---------------------------------------------------------
vim.o.termguicolors = true
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true
vim.opt.wrap = true -- turn on line wrapping
vim.opt.wrapmargin = 8 -- wrap lines when coming within n characters from side
vim.opt.linebreak = true -- set soft wrapping
vim.opt.showbreak = "↪"
vim.opt.autoindent = true -- automatically set indent of new line
vim.opt.ttyfast = true -- faster redrawing
table.insert(vim.opt.diffopt, "vertical")
table.insert(vim.opt.diffopt, "iwhite")
table.insert(vim.opt.diffopt, "internal")
table.insert(vim.opt.diffopt, "algorithm:patience")
table.insert(vim.opt.diffopt, "hiddenoff")
vim.opt.laststatus = 3 -- show the global statusline all the time
vim.opt.scrolloff = 7 -- set 7 lines to the cursors - when moving vertical
vim.opt.wildmenu = true -- enhanced command line completion
vim.opt.hidden = true -- current buffer can be put into background
vim.opt.showcmd = true -- show incomplete commands
vim.opt.showmode = true -- don't show which mode disabled for PowerLine
vim.opt.wildmode = { "list", "longest" } -- complete files like a shell
vim.opt.shell = vim.env.SHELL
vim.opt.cmdheight = 0 -- hide command bar when not used
vim.opt.title = true -- set terminal title
vim.opt.showmatch = true -- show matching braces
vim.opt.mat = 2 -- how many tenths of a second to blink
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.opt.shortmess = "atToOFc" -- prompt message options

-- Tab control
vim.opt.smarttab = true -- tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
vim.opt.tabstop = 4 -- the visible width of tabs
vim.opt.softtabstop = 4 -- edit as if the tabs are 4 characters wide
vim.opt.shiftwidth = 4 -- number of spaces to use for indent and unindent
vim.opt.shiftround = true -- round indent to a multiple of 'shiftwidth'

-- toggle invisible characters
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  trail = "⋅",
  extends = "❯",
  precedes = "❮",
}

-- hide the ~ character on empty lines at the end of the buffer
vim.opt.fcs = "eob: "

-- Mappings
-- vim.g.mapleader = ","
vim.g.mapleader = " "

nnoremap("Q", "<nop>")
imap("jk", "<Esc>", { desc = "escape" })
-- nmap("<leader>,", ":silent w<cr>", { desc = "save file" })
nmap(",,", ":silent w<cr>", { desc = "save file" })
inoremap("<C-j>", [[v:lua.completion_nvim.smart_pumvisible('<C-n>', '<C-j>')]], { expr = true })
inoremap("<C-k>", [[v:lua.completion_nvim.smart_pumvisible('<C-p>', '<C-k>')]], { expr = true })
vmap("<", "<gv")
vmap(">", ">gv")
nmap("<leader>.", "<c-^>")
vmap(".", ":normal .<cr>")
nnoremap("<CR>", ":noh<CR><CR>")

nmap("<C-h>", "<Plug>WinMoveLeft")
nmap("<C-j>", "<Plug>WinMoveDown")
nmap("<C-k>", "<Plug>WinMoveUp")
nmap("<C-l>", "<Plug>WinMoveRight")

-- moving up and down work as you would expect
nnoremap("j", 'v:count == 0 ? "gj" : "j"', { expr = true })
nnoremap("k", 'v:count == 0 ? "gk" : "k"', { expr = true })
nnoremap("^", 'v:count == 0 ? "g^" :  "^"', { expr = true })
nnoremap("$", 'v:count == 0 ? "g$" : "$"', { expr = true })

-- show current file path
vim.api.nvim_set_keymap("n", "<leader>fp", ":echo expand('%:p')<CR>", { noremap = true, silent = true })

local theme = require("theme")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
}, { ui = { border = theme.border } })

vim.cmd.colorscheme("catppuccin")
vim.cmd([[syntax on]])
vim.cmd([[filetype plugin indent on]])

-- remove trailing whitespace on save
vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]])

-- set up custom symbols for LSP errors
local signs =
  { Error = icons.error, Warning = icons.warning, Warn = icons.warning, Hint = icons.hint, Info = icons.hint }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({ virtual_text = true, signs = true, update_in_insert = true, severity_sort = true })
