# Apple Music for Linux

Provides a desktop launcher for Apple Music on Linux. It appears as a separate application in your desktop environment.

## Features

- Uses Chrome or Chromium browser in app mode for a clean, native-like interface.
- Runs as a separate application with its own dock/task manager icon.
- Log in once (authentication persists across sessions). Supports passkeys for Face ID login.
- Native desktop integration with proper icon and category.

## Prerequisites

### Required Software

1. **Flatpak** (1.12.0 or later)
   ```bash
   sudo apt install flatpak  # Debian/Ubuntu
   sudo dnf install flatpak  # Fedora
   ```

2. **Flatpak Builder**
   ```bash
   sudo apt install flatpak-builder  # Debian/Ubuntu
   sudo dnf install flatpak-builder  # Fedora
   ```

3. **Flathub Repository**
   ```bash
   flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
   ```

4. **Freedesktop Runtime and SDK**
   ```bash
   flatpak install --user flathub org.freedesktop.Platform//25.08
   flatpak install --user flathub org.freedesktop.Sdk//25.08
   ```

5. **Chrome or Chromium Browser** (required dependency)
   ```bash
   flatpak install --user flathub org.chromium.Chromium
   # OR
   flatpak install --user flathub com.google.Chrome
   ```

   **Note:** You must install Chrome or Chromium manually. The app will detect which one is installed and use it automatically.

## Building

### Local Build (Single Architecture)

1. **Clone or navigate to the project directory:**
   ```bash
   cd apple-music-flatpak
   ```

2. **Build and install the Flatpak:**
      ```bash
      flatpak-builder --force-clean --user --repo=repo --install build-dir me.santisbon.AppleMusic.yaml
      ```

### Share the app with a single-file bundle

```bash
flatpak build-bundle repo apple-music.flatpak me.santisbon.AppleMusic --runtime-repo=https://flathub.org/repo/flathub.flatpakrepo
```
Now you can send the .flatpak file to someone and if they have the Flathub repository set up and a working network connection to install the runtime/sdk, they can install Apple Music with:
```bash
flatpak install flathub org.freedesktop.Platform//25.08
flatpak install flathub org.freedesktop.Sdk//25.08

flatpak install --user apple-music.flatpak
```

## Testing

### Test the Installation

1. **Verify the app is installed:**
   ```bash
   flatpak list | grep apple
   ```

2. **Check desktop files are exported:**
   ```bash
   ls ~/.local/share/flatpak/exports/share/applications/ | grep apple
   ```

3. **Test the service:**
   ```bash
   flatpak run me.santisbon.AppleMusic music
   ```

4. **Launch from desktop environment:**
   - Open your application menu
   - Search for "Apple Music"
   - Launch the service
   - Verify it opens in app mode (no address bar)
   - Log in and test functionality

### Testing Checklist

- [x] Desktop launcher appears in application menu
- [x] Icon displays correctly
- [x] Launches in app mode (no address bar)
- [x] Has its own dock icon (not grouped with other apps)
- [x] Apple Music loads properly
- [x] Login persists across sessions
- [x] Network connectivity works

## Troubleshooting

### Icon Not Showing

If the icon doesn't appear:
```bash
gtk-update-icon-cache ~/.local/share/flatpak/exports/share/icons/hicolor
```

### Chrome/Chromium Not Found

Ensure the browser is installed e.g.
```bash
flatpak install --user flathub org.chromium.Chromium
```

### Logout / Clear Data

The service has its own Chromium profile. To logout:
```bash
rm -rf ~/.var/app/org.chromium.Chromium/config/apple-music
```

Alternatively, clear cookies:
1. Open the Apple Music service
2. Click the menu (three dots) in Chromium
3. Go to Settings → Privacy and security → Clear browsing data
4. Select "Cookies and other site data" for apple.com

### Desktop File Not Appearing

Update desktop database:
```bash
update-desktop-database ~/.local/share/flatpak/exports/share/applications
```

### Permission Issues

The app requires these minimal permissions:
- `--share=ipc` - Inter-process communication for X11 compatibility
- `--socket=wayland` / `--socket=fallback-x11` - Desktop environment integration
- `--talk-name=org.freedesktop.Flatpak` - Permission to spawn Chromium as a separate Flatpak

Note: Network access, GPU, and other browser permissions are handled by Chromium running in its own sandbox.

## Uninstalling

```bash
flatpak uninstall me.santisbon.AppleMusic
flatpak uninstall --unused  # Remove unused runtimes
```

## Development

### Modifying Desktop File

Edit the file in `desktop-files/` then rebuild:
```bash
flatpak-builder --user --install --force-clean build-dir me.santisbon.AppleMusic.yaml
```

### Adding New Services

1. Add URL to `scripts/launch-music.sh`
2. Create corresponding .desktop file
3. Download icon for new service
4. Update manifest to install new desktop file and icon

## Disclaimer and Attribution

Disclaimer: This project is provided as-is, without any warranty or guarantee. Use at your own risk.

Apple Music is a trademark of Apple Inc. This is an unofficial third-party application not affiliated with Apple Inc. Icon by The Cross-Platform Organization (https://github.com/cross-platform) under GNU GPL v3.

## See Also

- [Freedesktop Runtime](https://docs.flatpak.org/en/latest/available-runtimes.html) - [Releases](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/wikis/Releases)
