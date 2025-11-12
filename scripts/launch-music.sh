#!/bin/bash
# Main Apple Music Launcher
# This script launches Apple Music using Chromium browser

SERVICE="$1"

case "$SERVICE" in
    music)
        URL=https://music.apple.com
        WM_CLASS=apple-music
        ;;
    *)
        echo "Usage: $0 {music}"
        exit 1
        ;;
esac

# Detect which Chromium-based browser is installed
if flatpak-spawn --host flatpak list --app | grep -q "com.google.Chrome"; then
    BROWSER="com.google.Chrome"
    DATA_DIR="$HOME/.var/app/com.google.Chrome/config/apple-${SERVICE}"
elif flatpak-spawn --host flatpak list --app | grep -q "org.chromium.Chromium"; then
    BROWSER="org.chromium.Chromium"
    DATA_DIR="$HOME/.var/app/org.chromium.Chromium/config/apple-${SERVICE}"
else
    echo "Error: Neither Chrome nor Chromium is installed."
    echo "Please install one of them:"
    echo "  flatpak install flathub com.google.Chrome"
    echo "  flatpak install flathub org.chromium.Chromium"
    exit 1
fi

# Launch browser in app mode with custom window class and separate profile
# --class flag sets WM_CLASS to match StartupWMClass in desktop files for proper icon matching
# --user-data-dir creates separate profile per service for separate dock icons
# --ozone-platform=x11 forces X11/XWayland mode for proper window class handling on Wayland
# Note: Each service needs its own login (one-time setup per service)
exec flatpak-spawn --host flatpak run "$BROWSER" \
    --class="$WM_CLASS" \
    --user-data-dir="$DATA_DIR" \
    --ozone-platform=x11 \
    --app="$URL"
