#!/usr/bin/env bash

function check_prog() {
    if ! hash "$1" > /dev/null 2>&1; then
        echo "Command not found: $1. Aborting..."
        exit 1
    fi
}

check_prog stow

# ZSH
stow --target "$HOME" zsh

[[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"
    if ! grep "$zsh_path" /etc/shells; then
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        echo "default shell changed to $zsh_path"
    fi

# Config
stow --target "$HOME" --no-folding config

# Tmux theme
CATPPUCCIN_DIR="$HOME/.config/tmux/plugins/catppuccin"

if [ ! -d "$CATPPUCCIN_DIR" ]; then
    echo "Catppuccin Tmux plugin not found. Installing..."
    mkdir -p "$CATPPUCCIN_DIR"
    git clone -b v2.1.1 https://github.com/catppuccin/tmux.git "$CATPPUCCIN_DIR"
    echo "Catppuccin Tmux plugin installed successfully."
else
    echo "Catppuccin Tmux plugin is already installed."
fi

# MacOS
echo "Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "show hidden files by default"
defaults write com.apple.Finder AppleShowAllFiles -bool true

echo "only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

echo "expand save dialog by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "show the ~/Library folder in Finder"
chflags nohidden ~/Library

echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Use current directory as default search scope in Finder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Show Path bar in Finder"
defaults write com.apple.finder ShowPathbar -bool true

echo "Show Status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

echo "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1

echo "Set a shorter Delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "Enable tap to click (Trackpad)"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

echo "Reduce dock tile size"
defaults write com.apple.dock tilesize -int 52

echo "Auto hide dock"
defaults write com.apple.dock autohide -bool true

echo "Enable tap to click"
defaults -currentHost write -globalDomain com.apple.mouse.tapBehavior -int 1
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

echo "Disable showing recent apps"
defaults write com.apple.dock show-recents -bool false

echo "Kill affected applications"

for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
