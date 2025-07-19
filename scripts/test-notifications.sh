#!/bin/bash

# Test script to verify that notifications work from cron environment

echo "Testing notification system..."

# Set up environment (same as wrapper script)
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Test basic notify-send
echo "1. Testing basic notify-send..."
if notify-send "Dotfiles Test" "Basic notification test" --icon=dialog-information 2>/dev/null; then
    echo "   ✓ Basic notify-send works"
else
    echo "   ✗ Basic notify-send failed"
fi

# Test gdbus method (GNOME)
echo "2. Testing gdbus method..."
if command -v gdbus >/dev/null 2>&1; then
    if gdbus call --session \
        --dest org.freedesktop.Notifications \
        --object-path /org/freedesktop/Notifications \
        --method org.freedesktop.Notifications.Notify \
        "Dotfiles" 0 "dialog-information" "Test via gdbus" "This is a test via gdbus" "[]" "{}" 5000 \
        2>/dev/null; then
        echo "   ✓ gdbus method works"
    else
        echo "   ✗ gdbus method failed"
    fi
else
    echo "   ✗ gdbus not available"
fi

# Show environment info
echo ""
echo "Environment info:"
echo "DISPLAY=$DISPLAY"
echo "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS"
echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
echo "USER=$(whoami)"
echo "UID=$(id -u)"

echo ""
echo "D-Bus socket check:"
if [ -S "$XDG_RUNTIME_DIR/bus" ]; then
    echo "   ✓ D-Bus socket exists at $XDG_RUNTIME_DIR/bus"
else
    echo "   ✗ D-Bus socket not found at $XDG_RUNTIME_DIR/bus"
fi

echo ""
echo "X11 socket check:"
for display_num in 0 1 2; do
    if [ -S "/tmp/.X11-unix/X${display_num}" ]; then
        echo "   ✓ X11 socket exists for display :${display_num}"
    fi
done

echo ""
echo "Test completed."
