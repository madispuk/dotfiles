return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    config = function()
      require("mason").setup({ ui = { check_outdated_packages_on_open = true } })

      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Language servers
          "typescript-language-server",
          "tailwindcss-language-server",
          "lua-language-server",
          "vim-language-server",
          "json-lsp",
          "basedpyright",
          "ruff",
          "html-lsp",
          -- Linters and formatters (shellcheck and stylua come from the Brewfile;
          -- stylelint is resolved per-project out of node_modules/.bin)
          "htmlhint",
          "prettier",
          "shfmt",
        },
      })
    end,
  },

  -- LSP.
  --
  -- nvim-lspconfig is not used as a "setup" plugin. On Nvim 0.11+ it only ships
  -- `lsp/<name>.lua` definitions that Nvim resolves off the 'runtimepath', so it
  -- supplies cmd, filetypes, root detection and server-specific commands and
  -- handlers that are tedious to maintain by hand. Per-server overrides live in
  -- `after/lsp/<name>.lua`, which wins over the plugin's copy (:h lsp-config-merge).
  --
  -- Useful commands: `:lsp restart|enable|disable`, `:checkhealth vim.lsp`.
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "saghen/blink.cmp" },
    config = function()
      -- Advertise blink.cmp's completion capabilities to every server. blink does
      -- not register these itself; without them a server only sees Nvim's stock
      -- capabilities, so snippet expansion and auto-import-on-accept
      -- (resolveSupport.additionalTextEdits) silently do not work. Nvim merges
      -- its own defaults underneath, so only blink's additions belong here.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(nil, false),
      })

      vim.lsp.enable({
        "ts_ls",
        "tailwindcss",
        "lua_ls",
        "vimls",
        "jsonls",
        "basedpyright",
        "ruff",
        "html",
      })

      -- LSP keymaps and per-client features
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

          -- Only map what this client can actually answer, so e.g. `go` is not
          -- silently dead on a buffer served only by ruff.
          local map = function(keys, func, desc, method)
            if method and not client:supports_method(method) then
              return
            end
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", Snacks.picker.lsp_definitions, "Goto Definition", "textDocument/definition")
          map("gR", Snacks.picker.lsp_references, "Goto References", "textDocument/references")
          map("gI", Snacks.picker.lsp_implementations, "Goto Implementation", "textDocument/implementation")
          map("go", Snacks.picker.lsp_type_definitions, "Type Definition", "textDocument/typeDefinition")
          map("gO", Snacks.picker.lsp_symbols, "Document Symbols", "textDocument/documentSymbol")
          map("gw", Snacks.picker.lsp_workspace_symbols, "Workspace Symbols", "workspace/symbol")
          map("ga", vim.lsp.buf.code_action, "Code Action", "textDocument/codeAction")
          map("S", vim.lsp.buf.signature_help, "Signature Help", "textDocument/signatureHelp")

          -- Editing an opening tag updates its closing tag (html, jsx). Nvim 0.12.
          if client:supports_method("textDocument/linkedEditingRange") then
            vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
          end
        end,
      })

      vim.keymap.set("n", "<leader>uh", function()
        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
        vim.notify("inlay hints: " .. (enabled and "off" or "on"))
      end, { desc = "Toggle inlay hints" })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        handlebars = { "htmlhint" },
        html = { "htmlhint" },
        -- shellcheck is a linter. conform ships a `shellcheck` *formatter* that
        -- pipes `--format=diff` through patch and rewrites the file, which is not
        -- what you want on save; it belongs here instead.
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }
      -- Disable doctype rule for partials/templates
      lint.linters.htmlhint.args = {
        "--format",
        "json",
        "--rules",
        "doctype-first:false",
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
    opts = function()
      -- stylelint is only worth running when the project configures it; listing it
      -- unconditionally makes conform warn "Formatter 'stylelint' unavailable" on
      -- every CSS buffer elsewhere.
      local stylelint_configs = {
        ".stylelintrc",
        ".stylelintrc.json",
        ".stylelintrc.yml",
        ".stylelintrc.yaml",
        ".stylelintrc.js",
        ".stylelintrc.cjs",
        ".stylelintrc.mjs",
        "stylelint.config.js",
        "stylelint.config.cjs",
        "stylelint.config.mjs",
      }

      local function css_formatters(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)
        local from = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
        local found = vim.fs.find(stylelint_configs, { upward = true, path = from })[1]
        return found and { "stylelint", "prettier" } or { "prettier" }
      end

      return {
        format_on_save = {
          timeout_ms = 2000,
          lsp_format = "never",
        },
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          -- ruff_organize_imports is required: basedpyright's organize-imports is
          -- disabled and the ruff *server*'s only runs as an explicit code action,
          -- so without this imports are never sorted on save.
          python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
          astro = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          html = { "prettier" },
          liquid = { "prettier" },
          yaml = { "prettier" },
          css = css_formatters,
          sh = { "shfmt" },
          lua = { "stylua" },
          handlebars = { "prettier" },
          terraform = { "tofu_fmt" },
          -- `tf` is not a filetype: *.tf is `terraform`, *.tfvars is `terraform-vars`.
          ["terraform-vars"] = { "tofu_fmt" },
        },
      }
    end,
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
