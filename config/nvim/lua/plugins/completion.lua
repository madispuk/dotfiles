return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "zbirenbaum/copilot-cmp",
      -- "onsails/lspkind-nvim",
      {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
      },
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
      },
      "saadparwaiz1/cmp_luasnip", -- { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    config = function()
      -- local lspkind = require("lspkind")
      local cmp = require("cmp")
      -- local tailwind_formatter = require("tailwindcss-colorizer-cmp").formatter
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        ghost_text = { enabled = true },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = {
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-n>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-p>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer", keyword_length = 5, max_item_count = 5 },
          { name = "path" },
          { name = "copilot" },
          { name = "luasnip" },
          { name = "nvim_lua" },
        }),
        -- formatting = {
        --   fields = { cmp.ItemField.Menu, cmp.ItemField.Abbr, cmp.ItemField.Kind },
        --   format = lspkind.cmp_format({
        --     with_text = true,
        --     before = tailwind_formatter,
        --   }),
        -- },
        window = {
          completion = {
            border = "rounded",
          },
          documentation = {
            border = "rounded",
          },
        },
      })
    end,
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
