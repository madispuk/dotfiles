return {
  -- ========================================
  -- Core Editing Enhancements
  -- ========================================
  -- Comment/uncomment code with gc motions
  "tpope/vim-commentary",
  -- Surround text with quotes, brackets, tags, etc.
  "tpope/vim-surround",
  -- Enable repeating plugin maps with .
  "tpope/vim-repeat",
  -- Pairs of handy bracket mappings (]q, [q, ]b, [b, etc.)
  "tpope/vim-unimpaired",
  -- Automatically adjust shiftwidth and expandtab based on file
  "tpope/vim-sleuth",
  -- Enhanced % matching for if/else, HTML tags, etc.
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  -- ========================================
  -- Git Integration
  -- ========================================
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    lazy = false,
    keys = {
      { "<leader>gr", "<cmd>Gread<cr>", desc = "read file from git" },
      { "<leader>gb", "<cmd>G blame<cr>", desc = "read file from git" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      {
        "<leader>gd",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "toggle diff view",
      },
      {
        "<leader>gc",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen HEAD~1..HEAD")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "toggle diff view",
      },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "file history" },
    },
    opts = {},
  },

  -- ========================================
  -- Search & Replace
  -- ========================================
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

  -- ========================================
  -- UI Components & Enhancements
  -- ========================================
  -- UI component library (used by noice and other plugins)
  { "MunifTanjim/nui.nvim", lazy = true },
  -- Improve default neovim UI interfaces (select, input, etc.)
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  -- Tabline configuration
  { "alvarosevilla95/luatab.nvim", config = true },

  -- ========================================
  -- Development Tools
  -- ========================================
  -- Neovim Lua development tools (replaces neodev for nvim 0.11+)
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  -- Type definitions for Lua libraries (used by lazydev)
  { "Bilal2453/luvit-meta", lazy = true },
  -- Automatically install Mason tools
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  -- Flutter development tools
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = true,
  },
}
