#!/bin/bash

# Bluetooth toggle script for Waybar
# Toggles Bluetooth power on/off

if bluetoothctl show | grep -q "Powered: yes"; then
  bluetoothctl power off
else
  bluetoothctl power on
fi