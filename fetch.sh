#!/bin/bash

# Copy directories to ~/.config/
cp -r $(pwd)/ghostty ~/.config/ghostty
cp -r $(pwd)/hypr ~/.config/hypr
cp -r $(pwd)/nvim ~/.config/nvim
cp -r $(pwd)/rofi ~/.config/rofi
cp -r $(pwd)/waybar ~/.config/waybar

# Copy root files to ~/
cp $(pwd)/.gitignore ~/.gitignore
cp $(pwd)/.zprofile ~/.zprofile
cp $(pwd)/.zshrc ~/.zshrc