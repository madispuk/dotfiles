local M = {}

-- Simple wrappers around vim.keymap.set for backwards compatibility
local function make_map(mode, remap)
  return function(lhs, rhs, opts)
    opts = opts or {}
    opts.remap = remap
    opts.silent = opts.silent == nil and true or opts.silent
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

M.nmap = make_map("n", true)
M.imap = make_map("i", true)
M.vmap = make_map("v", true)

M.nnoremap = make_map("n", false)
M.xnoremap = make_map("x", false)
M.onoremap = make_map("o", false)

return M
