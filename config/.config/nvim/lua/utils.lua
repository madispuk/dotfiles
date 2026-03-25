local api = vim.api
local fn = vim.fn
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
M.xmap = make_map("x", true)
M.imap = make_map("i", true)
M.vmap = make_map("v", true)
M.omap = make_map("o", true)
M.tmap = make_map("t", true)
M.smap = make_map("s", true)
M.cmap = make_map("c", true)

M.nnoremap = make_map("n", false)
M.xnoremap = make_map("x", false)
M.vnoremap = make_map("v", false)
M.inoremap = make_map("i", false)
M.onoremap = make_map("o", false)
M.tnoremap = make_map("t", false)
M.cnoremap = make_map("c", false)

function M.has_map(map, mode)
  mode = mode or "n"
  return fn.maparg(map, mode) ~= ""
end

function M.has_module(name)
  if pcall(function()
    require(name)
  end) then
    return true
  else
    return false
  end
end

function M.termcodes(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

function M.file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

function M.has_active_lsp_client(servername)
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == servername then
      return true
    end
  end
  return false
end

return M
