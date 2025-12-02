# # Start Hyprland automatically if on tty1 and not inside X11
# if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
#     exec Hyprland
# fi

