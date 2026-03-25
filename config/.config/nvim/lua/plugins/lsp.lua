return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({ ui = { check_outdated_packages_on_open = true } })

      local mason_packages = {
        "typescript-language-server",
        "tailwindcss-language-server",
        "lua-language-server",
        "vim-language-server",
        "json-lsp",
        "basedpyright",
        "ruff",
        "html-lsp",
        "htmlhint",
      }
      require("mason-tool-installer").setup({ ensure_installed = mason_packages })
    end,
  },

  -- Native LSP configuration
  {
    name = "lsp-config",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    config = function()
      -- TypeScript/JavaScript
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
        -- handlers = {
        --   ["textDocument/definition"] = function(err, result, ctx, ...)
        --     if result and #result > 1 then
        --       result = { result[1] }
        --     end
        --     vim.lsp.handlers["textDocument/definition"](err, result, ctx, ...)
        --   end,
        -- },
        -- settings = {
        --   typescript = {
        --     inlayHints = {
        --       includeInlayParameterNameHints = "all",
        --       includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        --       includeInlayFunctionParameterTypeHints = true,
        --       includeInlayVariableTypeHints = true,
        --       includeInlayPropertyDeclarationTypeHints = true,
        --       includeInlayFunctionLikeReturnTypeHints = true,
        --       includeInlayEnumMemberValueHints = true,
        --     },
        --     preferences = {
        --       importModuleSpecifier = "relative",
        --     },
        --   },
        --   javascript = {
        --     inlayHints = {
        --       includeInlayParameterNameHints = "all",
        --       includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        --       includeInlayFunctionParameterTypeHints = true,
        --       includeInlayVariableTypeHints = true,
        --       includeInlayPropertyDeclarationTypeHints = true,
        --       includeInlayFunctionLikeReturnTypeHints = true,
        --       includeInlayEnumMemberValueHints = true,
        --     },
        --     preferences = {
        --       importModuleSpecifier = "relative",
        --     },
        --   },
        -- },
      }

      -- Tailwind CSS
      vim.lsp.config.tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "tailwind.config.js", "tailwind.config.ts", "package.json", ".git" },
        settings = {
          tailwindCSS = {
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidConfigPath = "error",
              invalidScreen = "error",
              invalidTailwindDirective = "error",
              recommendedVariantOrder = "warning",
              unusedClass = "warning",
            },
            validate = true,
          },
        },
      }

      -- Lua
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = {
          ".luarc.json",
          ".luarc.jsonc",
          ".luacheckrc",
          ".stylua.toml",
          "stylua.toml",
          "selene.toml",
          "selene.yml",
          ".git",
        },
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      }

      -- Vim
      vim.lsp.config.vimls = {
        cmd = { "vim-language-server", "--stdio" },
        filetypes = { "vim" },
        root_markers = { ".git" },
      }

      -- JSON
      vim.lsp.config.jsonls = {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { ".git" },
      }
      -- Python
      vim.lsp.config.basedpyright = {
        name = "basedpyright",
        filetypes = { "python" },
        cmd = { "basedpyright-langserver", "--stdio" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            analysis = {
              autoSearchPaths = true,
              autoImportCompletions = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
              inlayHints = {
                variableTypes = true,
                callArgumentNames = true,
                functionReturnTypes = true,
                genericTypes = false,
              },
            },
          },
        },
      }

      -- HTML
      vim.lsp.config.html = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html", "handlebars" },
        root_markers = { "package.json", ".git" },
      }

      -- Enable all servers
      vim.lsp.enable({ "ts_ls", "tailwindcss", "lua_ls", "vimls", "jsonls", "basedpyright", "html" })

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
          map("gR", require("telescope.builtin").lsp_references, "Goto References")
          map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
          map("go", require("telescope.builtin").lsp_type_definitions, "Type Definition")
          map("gw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
          map("ga", vim.lsp.buf.code_action, "Code Action")
          map("gr", vim.lsp.buf.rename, "Rename")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("S", vim.lsp.buf.signature_help, "Signature Help")
        end,
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        handlebars = { "htmlhint" },
        html = { "htmlhint" },
      }
      -- Disable doctype rule for partials/templates
      lint.linters.htmlhint.args = {
        "--format", "json",
        "--rules", "doctype-first:false",
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = false,
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        python = { "ruff_fix", "ruff_format" },
        astro = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        liquid = { "prettier" },
        yaml = { "prettier" },
        css = { "stylelint", "prettier" },
        sh = { "shellcheck", "shfmt" },
        lua = { "stylua" },
        handlebars = { "prettier" },
        terraform = { "tofu_fmt" },
        tf = { "tofu_fmt" },
      },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {
      auto_refresh = true,
      focus = true,
      preview = {
        type = "main",
        scratch = true,
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      -- Inline diagnostic popup (not trouble-specific)
      {
        "<leader>e",
        function()
          vim.diagnostic.open_float()
        end,
        desc = "Show diagnostic under cursor",
      },
    },
  },
  {
    "vuki656/package-info.nvim",
    config = true,
  },
}
