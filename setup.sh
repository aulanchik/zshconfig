#!/bin/bash

# Setup script for zsh aliases configuration
# This script automates the setup of zsh aliases by copying the alias file and updating .zshrc
# Author: Artyom Ulanchik

echo "Starting zsh aliases setup..."

# Check if running from the correct directory (where .zsh_aliases exists)
if [ ! -f ".zsh_aliases" ]; then
    echo "Error: .zsh_aliases file not found in current directory. Please run this script from the repository root."
    exit 1
fi

# Backup existing .zsh_aliases if it exists
if [ -f "$HOME/.zsh_aliases" ]; then
    echo "Backing up existing .zsh_aliases to .zsh_aliases.backup"
    cp "$HOME/.zsh_aliases" "$HOME/.zsh_aliases.backup"
fi

# Copy .zsh_aliases to home directory
cp .zsh_aliases "$HOME/.zsh_aliases"
echo "Copied .zsh_aliases to $HOME"

# Check if .zshrc exists
if [ ! -f "$HOME/.zshrc" ]; then
    echo "Warning: $HOME/.zshrc not found. Creating it."
    touch "$HOME/.zshrc"
fi

# Check if sourcing is already in .zshrc
if grep -q "source \"$HOME/.zsh_aliases\"" "$HOME/.zshrc"; then
    echo "Sourcing logic already present in .zshrc"
else
    echo "Appending sourcing logic to .zshrc"
    cat .zshrc_edit >> "$HOME/.zshrc"
fi

# Source .zshrc to apply changes
source "$HOME/.zshrc"
echo "Setup complete! Zsh aliases are now available in your terminal sessions."
