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

**IMPORTANT**: This configuration is for Neovim 0.11 and does not use any deprecated configuration options or APIs. When making changes, ensure compatibility with Neovim 0.11+ and avoid deprecated features.

The Neovim configuration uses lazy.nvim as the plugin manager:

- **Config location**: `config/.config/nvim/`
- **Entry point**: `config/.config/nvim/init.lua`
- **Plugins**: Individual plugin configurations in `config/.config/nvim/lua/plugins/`

Key plugin files:
- `plugins/lsp.lua` - LSP configuration
- `plugins/telescope.lua` - Fuzzy finder setup
- `plugins/completion.lua` - Auto-completion
- `plugins/treesitter.lua` - Syntax highlighting
- `plugins/ui.lua` - UI enhancements (lualine, bufferline, etc)
- `plugins/noice.lua` - UI for messages, cmdline and popover
- `plugins/fzf.lua` - FZF integration
- `plugins/core.lua` - Core editor plugins

The `utils.lua` module provides keymap helper functions (`nmap`, `nnoremap`, `imap`, etc) that are used throughout the configuration.

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
├── bin/              # Custom utility scripts added to PATH
├── config/           # XDG-style config files (stowed to ~/.config/)
│   └── .config/
│       ├── nvim/     # Neovim configuration (Lua-based, lazy.nvim)
│       ├── tmux/     # Tmux configuration
│       ├── git/      # Git configuration
│       ├── kitty/    # Kitty terminal config
│       ├── bat/      # Bat (cat alternative) config
│       ├── ripgrep/  # Ripgrep configuration
│       └── aerospace/ # AeroSpace window manager config
├── zsh/              # Zsh configuration (stowed to ~/)
│   └── .zshrc        # Main zsh config
├── Brewfile          # Homebrew package definitions
└── install.sh        # Installation script
```

### Stow-based Architecture

The repository uses GNU Stow to manage symlinks. Each top-level directory (except `bin/`) is a "stow package":
- `zsh/` directory contents are symlinked directly to `$HOME`
- `config/` directory contents are symlinked to `$HOME` with `--no-folding` to prevent directory merging

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
- Adds `$DOTFILES/bin` to PATH for custom scripts
- Defines `$CODE_DIR` (~/dev) for project navigation
- Custom minimal prompt showing pwd and git branch

### Custom Utility Scripts

The `bin/` directory contains various shell utilities that are added to PATH:
- Git utilities: `git-bare-clone`, `git-clc`, `git-kill`, `git-modified`, `git-track`
- Development helpers: `t` (task management), `tm` (tmux wrapper), `manage` (docker-compose wrapper)
- System utilities: `killport`, `wtfport`, `jwt` (JWT decoder), `extract` (universal archive extractor)

## Theme and Visual Consistency

All tools use the Catppuccin Mocha theme:
- Neovim: `colorscheme catppuccin` in init.lua
- Tmux: Catppuccin plugin configured in tmux.conf
- Bat: Catppuccin themes installed during install.sh
- Shell: FZF colors configured to match in .zshrc
