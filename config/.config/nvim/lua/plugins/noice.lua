return {
  {
    "folke/noice.nvim",
    lazy = false,
    priority = 50,
    opts = {
      lsp = {
        -- Show LSP loading progress (e.g., "Loading workspace...", "Indexing...")
        -- Displayed in mini view (top-right corner) with 30fps throttle
        progress = {
          enabled = true,
          format = "lsp_progress",
          format_done = "lsp_progress_done",
          throttle = 1000 / 30, -- Update every ~33ms (30fps)
          view = "mini",
        },
        hover = {
          enabled = true,
          silent = true, -- Don't show "No information available" notifications
        },
        -- Auto-show function signatures while typing
        -- Appears when you type function name and opening parenthesis
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically trigger signature help
            luasnip = true, -- Show signatures when navigating luasnip placeholders
            throttle = 50, -- Update every 50ms
          },
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      -- Customize popup window appearance and positioning
      views = {
        -- Command-line popup (appears when you type ":" commands)
        -- Positioned near top-center for better visibility
        cmdline_popup = {
          position = {
            row = 5, -- 5 rows from top
            col = "50%", -- Centered horizontally
          },
          size = {
            width = 60,
            height = "auto",
          },
        },
        -- Completion menu (appears when typing commands with suggestions)
        -- Positioned just below the cmdline_popup
        popupmenu = {
          relative = "editor",
          position = {
            row = 8, -- Just below cmdline_popup
            col = "50%", -- Centered horizontally
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded", -- Rounded corners for modern look
            padding = { 0, 1 }, -- Horizontal padding for better spacing
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
      -- Control where different messages appear (or hide them entirely)
      -- routes = {
      --   -- Show file info (e.g., "123L, 4567B") in mini view instead of full notification
      --   -- This includes undo/redo position messages like "; after #3"
      --   {
      --     filter = {
      --       event = "msg_show",
      --       any = {
      --         { find = "%d+L, %d+B" }, -- Match "123L, 4567B" (lines, bytes)
      --         { find = "; after #%d+" }, -- Match "; after #3" (undo position)
      --         { find = "; before #%d+" }, -- Match "; before #2" (redo position)
      --       },
      --     },
      --     view = "mini", -- Show in mini view (top-right) instead of notification
      --   },
      --   -- Hide "written" messages that appear when saving files
      --   -- Example: "[No Name] 10L, 234B written"
      --   {
      --     filter = {
      --       event = "msg_show",
      --       kind = "",
      --       find = "written",
      --     },
      --     opts = { skip = true }, -- Completely hide this message
      --   },
      --   -- Hide search count messages (e.g., "[1/5]" when searching)
      --   -- These can be distracting during incremental search
      --   {
      --     filter = {
      --       event = "msg_show",
      --       kind = "search_count",
      --     },
      --     opts = { skip = true },
      --   },
      --   -- Hide "E486: Pattern not found" errors during search
      --   -- Reduces noise when typing search patterns that don't match
      --   {
      --     filter = {
      --       event = "msg_show",
      --       find = "^E486:",
      --     },
      --     opts = { skip = true },
      --   },
      --   -- Hide "No information available" LSP notifications
      --   -- Appears when hovering over items without documentation
      --   {
      --     filter = {
      --       event = "notify",
      --       find = "No information available",
      --     },
      --     opts = { skip = true },
      --   },
      -- },
      -- Customize cmdline appearance with icons and syntax highlighting
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          -- Normal vim commands starting with ":"
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          -- Forward search with "/"
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          -- Backward search with "?"
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          -- Shell commands (e.g., ":!ls", ":!git status")
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          -- Lua commands (e.g., ":lua print('hi')", ":=vim.version()")
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          -- Help commands (e.g., ":help", ":h")
          help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
          -- Default for input prompts
          input = {},
        },
      },
      -- Configure how different types of messages are displayed
      messages = {
        enabled = true,
        view = "notify", -- Default view for regular messages (uses nvim-notify)
        view_error = "notify", -- Show errors as notifications
        view_warn = "notify", -- Show warnings as notifications
        view_history = "messages", -- Message history shown in :messages view
        view_search = "virtualtext", -- Show search results as virtual text
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
