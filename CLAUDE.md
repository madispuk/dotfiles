# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS, managed using GNU Stow for symlinking configuration files. The repository contains shell configurations, Neovim setup, tmux configuration, and various utility scripts.

## Important Commands

### Installation and Setup

```bash
# Install all dotfiles (requires GNU stow)
./install.sh

# Install Homebrew packages
brew bundle --file=Brewfile

# Manually stow specific configurations
stow --target "$HOME" zsh
stow --target "$HOME" --no-folding config
```

### Neovim Configuration

**IMPORTANT**: This configuration is for Neovim 0.12 (managed by mise, pinned in `~/.config/mise/config.toml`) and does not use any deprecated configuration options or APIs. When making changes, ensure compatibility with Neovim 0.12+ and avoid deprecated features. nvim-treesitter and nvim-treesitter-textobjects track their rewritten `main` branches (which require the `tree-sitter-cli` Homebrew package); the old `nvim-treesitter.configs` module-based setup API no longer exists.

The Neovim configuration uses lazy.nvim as the plugin manager:

- **Config location**: `config/.config/nvim/`
- **Entry point**: `config/.config/nvim/init.lua`
- **Plugins**: Individual plugin configurations in `config/.config/nvim/lua/plugins/`

Key plugin files:
- `plugins/lsp.lua` - LSP, linting (nvim-lint) and formatting (conform.nvim) plugin specs
- `plugins/snacks.lua` - Fuzzy finder (snacks.nvim picker)
- `plugins/completion.lua` - Auto-completion
- `plugins/treesitter.lua` - Syntax highlighting
- `plugins/ui.lua` - UI enhancements (lualine, bufferline, etc)
- `plugins/noice.lua` - UI for messages, cmdline and popover
- `plugins/fzf.lua` - FZF integration
- `plugins/core.lua` - Core editor plugins

The `utils.lua` module provides keymap helper functions (`nmap`, `imap`, `vmap`, `nnoremap`, `xnoremap`, `onoremap`) that are used throughout the configuration. Only those six exist - do not assume other variants are available.

Pickers go through `Snacks.picker.*` (snacks.nvim); telescope was removed. Git signs come from `gitsigns.nvim`, which also feeds the lualine diff component via `vim.b.gitsigns_status_dict`.

#### LSP Server Configuration

**IMPORTANT**: Server definitions are NOT written by hand. `nvim-lspconfig` is installed purely for the `lsp/<name>.lua` files it ships, which Neovim 0.11+ resolves off the `runtimepath` - it provides `cmd`, `filetypes`, root detection and server-specific commands/handlers.

- Per-server overrides live in `config/.config/nvim/after/lsp/<name>.lua`, which wins over the plugin's copy (`:h lsp-config-merge`). Return a table; it is deep-merged.
- Only override what actually differs. A server needing no changes gets no file (`tailwindcss`, `html`, `jsonls` and `vimls` are all upstream defaults).
- Do NOT use `vim.lsp.config.<name> = {...}` (table assignment) - that **replaces** the resolved chain and would discard nvim-lspconfig's definition. Use `after/lsp/` or `vim.lsp.config("<name>", {...})`.
- Do NOT define `on_attach` in an override for a server whose upstream config has one (e.g. `basedpyright`) - functions are replaced, not merged, so its user commands would be lost.
- Shared settings go in the `vim.lsp.config("*", ...)` call in `plugins/lsp.lua`; the server list is the single `vim.lsp.enable({...})` call.
- Features that Neovim 0.12 requires to be enabled explicitly (inlay hints, linked editing) are turned on in the `LspAttach` handler, guarded by `client:supports_method()`. Server-side `inlayHints` settings do nothing without `vim.lsp.inlay_hint.enable()`.
- LSP keymaps deliberately avoid `gr`: it is the prefix for Neovim's default `grn`/`gra`/`grr`/`gri`/`grt`/`grx` maps, so binding `gr` itself stalls every press for `timeoutlen` and shadows all six. Rename is `grn`, hover is `K`.
- `blink.cmp`'s completion capabilities must be passed explicitly (blink does not register them itself); this happens once via `vim.lsp.config("*", ...)`.
- Use `:lsp restart|enable|disable` and `:checkhealth vim.lsp` (Neovim 0.12). Note checkhealth reports "Unknown filetype" warnings for entries in nvim-lspconfig's 50-filetype tailwindcss list - that is expected noise, not a problem.

Linters belong in `nvim-lint`, formatters in `conform.nvim`. Some tools exist as both (`shellcheck`, `stylelint`) - conform's `shellcheck` formatter rewrites the file via `--format=diff | patch`, which is not wanted on save.

#### Catppuccin Theme Cache

The Catppuccin theme uses compilation caching for performance. The cache is stored in `~/.cache/nvim/catppuccin/` and is **automatically cleared and recompiled on Neovim restart** when configuration changes are detected.

**IMPORTANT**: Do NOT manually delete the cache directory with `rm -rf`. Simply restart Neovim and the cache will be handled automatically.

### Git Configuration

Git configuration is split across files:
- `config/.config/git/config` - Main git config with extensive aliases
- `~/.gitconfig-local` - Local user-specific config (created during install.sh, not version controlled)

Notable git aliases include:
- `git s` - Short status (`status --short --branch`)
- `git l` - Pretty log graph
- `git pnb` - Push new branch with upstream tracking
- `git d` - Diff ignoring whitespace and lock files
- `git cane` - Commit amend no edit
- `git recent` - Show recently touched branches
- `git forget` - Clean up deleted remote branches

### Tmux Configuration

- **Config location**: `config/.config/tmux/tmux.conf`
- **Prefix key**: `Ctrl-a` (instead of default `Ctrl-b`)
- **Theme**: Catppuccin Mocha (installed in `~/.config/tmux/plugins/catppuccin`)
- **Key feature**: Lazygit popup bound to `prefix + g`

## Architecture and Structure

### Directory Layout

```
dotfiles/
├── config/           # XDG-style config files (stowed to ~/.config/)
│   └── .config/
│       ├── nvim/     # Neovim configuration (Lua-based, lazy.nvim)
│       │   ├── lua/plugins/  # lazy.nvim plugin specs
│       │   └── after/lsp/    # per-server LSP overrides on top of nvim-lspconfig
│       ├── tmux/     # Tmux configuration
│       ├── git/      # Git configuration
│       ├── ghostty/  # Ghostty terminal config
│       ├── bat/      # Bat (cat alternative) config
│       ├── ripgrep/  # Ripgrep configuration
│       └── aerospace/ # AeroSpace window manager config
├── zsh/              # Zsh configuration (stowed to ~/)
│   └── .zshrc        # Main zsh config
├── Brewfile          # Homebrew package definitions
└── install.sh        # Installation script
```

### Stow-based Architecture

The repository uses GNU Stow to manage symlinks. Each top-level directory is a "stow package":
- `zsh/` directory contents are symlinked directly to `$HOME`
- `config/` directory contents are symlinked to `$HOME` with `--no-folding` to prevent directory merging

**IMPORTANT**: `--no-folding` symlinks each file individually, not the directory. After adding or deleting any config file you must re-run `stow --target "$HOME" --no-folding config`, otherwise the new file is never linked and the deleted one leaves a dangling symlink.

### Neovim Plugin Architecture

The Neovim config follows a modular lazy.nvim structure:
1. `init.lua` bootstraps lazy.nvim and loads all plugins from `lua/plugins/`
2. Each file in `lua/plugins/` returns a Lua table (or array of tables) with plugin specs
3. Plugins are auto-loaded by lazy.nvim via `{ import = "plugins" }`
4. The `utils.lua` module provides consistent keymap creation across the config

Theme configuration is centralized in `lua/theme.lua` and uses the Catppuccin colorscheme (Mocha variant).

### Shell Environment

The `.zshrc` configuration:
- Sources Homebrew-installed zsh plugins (syntax-highlighting, autosuggestions)
- Integrates zoxide for smart directory jumping (aliased to `cd`)
- Uses fzf for fuzzy finding with fd as the default command
- Defines `$CODE_DIR` (~/dev) for project navigation
- Custom minimal prompt showing pwd only (no git branch)

## Theme and Visual Consistency

All tools use the Catppuccin Mocha theme:
- Neovim: `colorscheme catppuccin` in init.lua
- Tmux: Catppuccin plugin configured in tmux.conf
- Bat: Catppuccin Mocha (`--theme="Catppuccin Mocha"`; themes installed during install.sh)
- Shell: FZF colors configured to match in .zshrc
