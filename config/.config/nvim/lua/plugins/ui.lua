local theme = require("theme")
local icons = theme.icons

return {
  -- File type icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      strict = true,
    },
  },

  --{
  --  "yazi-rs/flavors",
  --  name = "yazi-flavor-catppuccin-mocha",
  --  lazy = true,
  --  build = function(spec)
  --    require("yazi.plugin").build_flavor(spec, { sub_dir = "catppuccin-mocha.yazi" })
  --  end,
  --},
  --{
  --  "mikavilpas/yazi.nvim",
  --  version = "*",
  --  event = "VeryLazy",
  --  dependencies = {
  --    { "nvim-lua/plenary.nvim", lazy = true },
  --  },
  --  keys = {
  --    { "<leader>k", "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
  --    { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open yazi in working directory" },
  --  },
  --  ---@type YaziConfig | {}
  --  opts = {
  --    open_for_directories = true,
  --    -- floating_window_scaling_factor = 0.9,
  --    -- yazi_floating_window_border = "rounded",
  --    keymaps = {
  --      show_help = "<f1>",
  --      open_file_in_vertical_split = "<c-v>",
  --      open_file_in_horizontal_split = "<c-x>",
  --      open_file_in_tab = "<c-t>",
  --      grep_in_directory = "<c-s>",
  --      cycle_open_buffers = "<tab>",
  --      copy_relative_path_to_selected_files = "<c-y>",
  --      send_to_quickfix_list = "<c-q>",
  --    },
  --  },
  --  init = function()
  --    vim.g.loaded_netrwPlugin = 1
  --  end,
  --},

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    opts = function()
      local diagnostics = {
        "diagnostics",
        sources = { "nvim_lsp" },
        sections = { "error", "warn", "info", "hint" },
        symbols = {
          error = icons.bug .. " ",
          hint = icons.hint,
          info = icons.info,
          warn = icons.warning,
        },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      }

      local diff = {
        "diff",
        symbols = {
          added = icons.added,
          modified = icons.modified,
          removed = icons.deleted,
        },
        colored = true,
        always_visible = false,
        source = function()
          ---@diagnostic disable-next-line: undefined-field
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      }

      local branch = {
        "branch",
        icon = icons.git,
        colored = true,
      }

      local filename = {
        "filename",
        path = 1,
        symbols = {
          modified = "[+]",
          readonly = "[-]",
          unnamed = "[No Name]",
        },
      }

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { branch, diff },
          lualine_c = { filename, diagnostics },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },

  -- Floating statuslines. This is used to show buffer names in splits
  { "b0o/incline.nvim", opts = { hide = { cursorline = false, focused_win = false, only_win = true } } },
  {
    "mhinz/vim-signify",
    config = function(_, _)
      vim.api.nvim_set_hl(0, "SignifySignAdd", { link = "GitSignsAdd" })
      vim.api.nvim_set_hl(0, "SignifySignChange", { link = "GitSignsChange" })
      vim.api.nvim_set_hl(0, "SignifySignChangeDelete", { link = "GitSignsChange" })
      vim.api.nvim_set_hl(0, "SignifySignDelete", { link = "GitSignsDelete" })
      vim.api.nvim_set_hl(0, "SignifySignDeleteFirstLine", { link = "GitSignsDelete" })

      vim.g.signify_sign_add = "▎"
      vim.g.signify_sign_change = "▎"
      vim.g.signify_sign_delete = ""
      vim.g.signify_sign_delete_first_line = ""
      vim.g.signify_sign_change_delete = ""
    end,
  },
  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "auto", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
      transparent_background = true,
      term_colors = true,
      compile = { enabled = true, path = vim.fn.stdpath("cache") .. "/catppuccin", suffix = "_compiled" },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = { "bold" },
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        blink_cmp = true,
        cmp = false,
        fzf = true,
        gitsigns = false,
        lsp_trouble = true,
        markdown = true,
        mason = true,
        neotree = false,
        noice = true,
        notify = true,
        signify = true,
        telescope = true,
        window_picker = true,
      },
      custom_highlights = function()
        return {
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
        }
      end,
    },
  },
  {
    "rcarriga/nvim-notify",
    keys = {},
    opts = {
      timeout = 3000,
      background_colour = "#303446",
      render = "minimal",
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        delete_to_trash = true,
        -- skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
          end,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 0,
        },
        win_options = {
          wrap = true,
          winblend = 0,
        },
        keymaps = {
          ["<C-c>"] = false,
          ["q"] = { "actions.close", nowait = true },
        },
      })
    end,
    keys = {
      { "-", "<cmd>Oil<cr>" },
    },
  },
}
