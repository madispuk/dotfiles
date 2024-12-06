return {
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    opts = {
      highlight = {
        use_nvim_cmp_as_default = true,
      },
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
      nerd_font_variant = "mono",
      -- trigger = { signature_help = { enabled = true } },
      windows = {
        autocomplete = {
          border = "rounded",
        },
        documentation = {
          border = "rounded",
          min_width = 10,
          max_width = 120,
          auto_show_delay_ms = 0,
        },
        signature_help = {
          min_width = 1,
          max_width = 120,
          max_height = 10,
          border = "rounded",
        },
      },
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
