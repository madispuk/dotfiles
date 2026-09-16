return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        enabled = true,
        ui_select = true, -- replace vim.ui.select with the snacks picker
        matcher = {
          frecency = true, -- boost frequently/recently opened entries
          cwd_bonus = true,
        },
        sources = {
          files = { hidden = true, ignored = true },
          grep = { hidden = true },
        },
        win = {
          input = {
            keys = {
              -- keep the telescope muscle memory
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<C-j>"] = { "list_down", mode = { "n", "i" } },
              ["<C-k>"] = { "list_up", mode = { "n", "i" } },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>ft",
        function()
          Snacks.picker()
        end,
        desc = "picker: all pickers",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "picker: all files",
      },
      {
        "<leader>t",
        function()
          Snacks.picker.git_files()
        end,
        desc = "picker: git files",
      },
      {
        "<leader>r",
        function()
          Snacks.picker.buffers()
        end,
        desc = "picker: open buffers",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "picker: live grep",
      },
      {
        "<leader>fs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "picker: git status",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.resume()
        end,
        desc = "picker: resume last",
      },
      {
        "<leader>fw",
        function()
          Snacks.picker.grep_word()
        end,
        mode = { "n", "x" },
        desc = "picker: grep word",
      },
    },
  },
}
