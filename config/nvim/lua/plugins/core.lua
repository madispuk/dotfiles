return {
  "tpope/vim-commentary",
  "tpope/vim-unimpaired",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    lazy = false,
    keys = {
      { "<leader>gr", "<cmd>Gread<cr>", desc = "read file from git" },
      { "<leader>gb", "<cmd>G blame<cr>", desc = "read file from git" },
    },
  },
  { "alvarosevilla95/luatab.nvim", config = true },
  -- UI component library (used for neotree)
  { "MunifTanjim/nui.nvim", lazy = true },
  -- improve the default neovim interfaces, such as refactoring
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  -- tools for helping with neovim development
  { "folke/neodev.nvim", config = true },
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
    keys = {
      { "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", desc = "open spectre" },
      { "<leader>sp", "<cmd>lua require('spectre').open_file_search()<cr>", desc = "open spectre" },
      { "<leader>ss", "<cmd>lua require('spectre').open()<cr>", desc = "open spectre" },
    },
  },
  {
    "nat-418/boole.nvim",
    opts = {
      mappings = {
        increment = "<C-a>",
        decrement = "<C-x>",
      },
      additions = {},
      allow_caps_additions = {
        { "enable", "disable" },
      },
    },
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
    },
  },
  "WhoIsSethDaniel/mason-tool-installer.nvim",
}
