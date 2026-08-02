return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- The rewritten `main` branch (requires nvim 0.12+ and the tree-sitter
    -- CLI) only manages parser installation; highlighting, indentation and
    -- selection are wired up manually below via core nvim APIs.
    branch = "main",
    version = false,
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local ts = require("nvim-treesitter")
      local ts_config = require("nvim-treesitter.config")
      ts.setup({})

      vim.treesitter.language.register("glimmer", "handlebars")

      local ensure_installed = {
        "bash",
        "comment",
        "css",
        "diff",
        "dockerfile",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "helm",
        "html",
        "http",
        "javascript",
        "json",
        "liquid",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "xml",
        "yaml",
      }
      local installed = ts_config.get_installed()
      local missing = vim.iter(ensure_installed)
        :filter(function(lang)
          return not vim.tbl_contains(installed, lang)
        end)
        :totable()
      if #missing > 0 then
        ts.install(missing)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end
          local function start()
            if pcall(vim.treesitter.start, ev.buf, lang) then
              vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end
          if vim.tbl_contains(ts_config.get_installed(), lang) then
            start()
          elseif vim.tbl_contains(ts_config.get_available(), lang) then
            -- replaces the old `auto_install = true`
            ts.install(lang):await(function()
              if vim.api.nvim_buf_is_valid(ev.buf) then
                start()
              end
            end)
          end
        end,
      })

      -- Incremental selection was removed from the plugin; nvim 0.12 has it
      -- built in (`an`/`in`/`]n`/`[n` in visual mode). Keep the old keymaps
      -- on top of the builtin for muscle memory. `grc` (scope incremental)
      -- has no builtin equivalent and is dropped.
      local utils = require("utils")
      utils.nnoremap("gnn", function()
        vim.treesitter.select("parent")
      end, { desc = "Start treesitter node selection" })
      utils.xnoremap("<C-g>", function()
        vim.treesitter.select("parent")
      end, { desc = "Grow selection to parent node" })
      utils.xnoremap("grm", function()
        vim.treesitter.select("child")
      end, { desc = "Shrink selection to child node" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    version = false,
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true, -- automatically jump forward to matching textobj
        },
      })

      local function select(query)
        return function()
          require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
        end
      end
      local utils = require("utils")
      for _, map in ipairs({
        { "af", "@function.outer" },
        { "if", "@function.inner" },
        { "ac", "@class.outer" },
        { "ic", "@class.inner" },
      }) do
        utils.xnoremap(map[1], select(map[2]))
        utils.onoremap(map[1], select(map[2]))
      end
    end,
  },
}
