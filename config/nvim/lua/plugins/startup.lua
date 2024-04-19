local headers = {
  neovim = {
    [[                                                     ]],
    [[                                                     ]],
    [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
    [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
    [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
    [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
    [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
    [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
  },
}

local group = vim.api.nvim_create_augroup("Startup", { clear = true })
vim.api.nvim_create_autocmd("FileType", { group = group, pattern = "startup", command = "setlocal list&" })

-- if in a git directory, open git files, otherwise open all files when pressing the "Find File" shortcut
local find_command = vim.fn.isdirectory(".git") and "Telescope git_files" or "Telescope find_files"

return {
  {
    "startup-nvim/startup.nvim",
    opts = {
      header = {
        type = "text",
        align = "center",
        fold_section = false,
        title = "Header",
        content = headers.neovim,
        highlight = "Constant",
      },
      body = {
        type = "mapping",
        align = "center",
        fold_section = false,
        title = "Basic Commands",
        margin = 5,
        content = {
          -- TODO can these be made without the mappings?
          { " Find File", find_command, "<leader>t" },
          { " Find Word", "Telescope live_grep", "<leader>fg" },
          { " Recent Files", "Telescope oldfiles", "<leader>fo" },
          { " Open File Drawer", "Neotree reveal toggle", "<leader>k" },
          { " New File", ":enew", "e" },
        },
        highlight = "Statement",
      },
      footer = {
        type = "text",
        align = "center",
        fold_section = false,
        title = "Footer",
        margin = 5,
        content = { "Head tööpäeva." },
        highlight = "Number",
        default_color = "",
      },
      colors = { background = "#1f2227", folded_section = "#56b6c2" },
      mappings = {
        execute_command = "<CR>",
        open_file = "o",
        open_file_split = "<c-o>",
        open_section = "<TAB>",
        open_help = "?",
        quit = "q",
      },
      options = {
        disable_statuslines = true,
        after = function()
          require("startup.utils").oldfiles_mappings()
        end,
      },
      parts = { "header", "body", "footer" },
    },
  },
}
