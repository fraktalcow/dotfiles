q#!/bin/bash

# Power menu script for Waybar
# Displays power options using walker

options="󰗽 Logout\n󰜉 Reboot\n󰐥 Shutdown\n󰤄 Sleep\n󰌾 Lock"

chosen=$(echo -e "$options" | walker -d -p "Power Menu")

case $chosen in
"󰗽 Logout")
  hyprctl dispatch exit
  ;;
"󰜉 Reboot")
  systemctl reboot
  ;;
"󰐥 Shutdown")
  systemctl poweroff
  ;;
"󰤄 Sleep")
  systemctl suspend
  ;;
"󰌾 Lock")
  hyprlock
  ;;
esac
