#!/bin/bash
set -e

REPO="$(pwd)"

# Pull latest from GitHub first
git pull

# Copy configs INTO the repo (not out)
cp -r ~/.config/ghostty "$REPO/ghostty"
cp -r ~/.config/hypr "$REPO/hypr"
cp -r ~/.config/nvim "$REPO/nvim"
cp -r ~/.config/waybar "$REPO/waybar"

# Copy root dotfiles INTO the repo
cp ~/.gitignore "$REPO/.gitignore"
cp ~/.zprofile "$REPO/.zprofile"
cp ~/.zshrc "$REPO/.zshrc"

# Commit + push
git add .
git commit -m "Update configs"
git push
