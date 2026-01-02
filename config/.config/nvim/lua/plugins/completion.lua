return {
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   version = false, -- Never set this value to "*"! Never!
  --   opts = {
  --     -- add any opts here
  --     -- for example
  --     provider = "openai",
  --     openai = {
  --       endpoint = "https://api.openai.com/v1",
  --       model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
  --       timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
  --       temperature = 0,
  --       max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
  --       --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- },
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    opts = {
      keymap = {
        ["<C-h>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<C-y>"] = { "select_and_accept" },

        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      completion = { documentation = { auto_show = true } },
    },
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        openai_params = {
          model = "gpt-4o",
          max_tokens = 4096,
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      {
        "<leader>l",
        "<cmd>ChatGPT<cr>",
        desc = "ChatGPT",
      },
      {
        "<leader>7",
        "<cmd>ChatGPTRun optimize_code<cr>",
        desc = "ChatGPT (optimize code)",
      },
      {
        "<leader>8",
        "<cmd>ChatGPTRun grammar_correction<cr>",
        desc = "ChatGPT (grammar correction)",
      },
      {
        "<leader>9",
        "<cmd>ChatGPTEditWithInstructions<cr>",
        desc = "ChatGPT (edit with instructions)",
      },
    },
  },
}
