#!/bin/bash

if ! command -v xdotool &> /dev/null; then
    echo "xdotool not found. Please install it: sudo pacman -S xdotool"
    rofi "$@"
    exit $?
fi

# Launch rofi
rofi "$@" &
ROFI_PID=$!

# Wait for rofi window to appear
for i in {1..20}; do
    sleep 0.05
    ROFI_WIN=$(xdotool search --class "rofi" 2>/dev/null | head -1)
    [ -n "$ROFI_WIN" ] && break
done

if [ -z "$ROFI_WIN" ]; then
    wait $ROFI_PID
    exit $?
fi

# Monitor focus and close rofi when it loses focus
while kill -0 $ROFI_PID 2>/dev/null; do
    sleep 0.05
    ACTIVE_WIN=$(xdotool getactivewindow 2>/dev/null)
    if [ -n "$ACTIVE_WIN" ] && [ "$ACTIVE_WIN" != "$ROFI_WIN" ]; then
        # Focus changed away from rofi, close it
        kill $ROFI_PID 2>/dev/null
        break
    fi
done

wait $ROFI_PID 2>/dev/null

