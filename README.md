# FileFlow — Install & Setup Guide

FileFlow is a desktop tray utility for tagging and uploading files to a backend server. This guide covers running the packaged app on Linux, with specific notes for Arch-based and Debian-based distros.

> **Note:** This assumes the AppImage build is complete. If you were handed a plain binary or the raw project instead, ask whoever built it for the packaged `.AppImage` file.

---

## 1. Requirements

FileFlow is distributed as a single **AppImage** — no Flutter, Dart, or dev tools needed to run it. You just need:

- A Linux desktop with a **system tray** available (see Section 3 — this is the main thing that varies by setup)
- `libfuse2` (most distros have this already; AppImages need it to run)

Check if you have it:

```bash
ldconfig -p | grep fuse
```

If nothing shows up:

**Arch-based (Arch, EndeavourOS, Manjaro):**
```bash
sudo pacman -S fuse2
```

**Debian-based (Debian, Ubuntu, Pop!_OS, Mint):**
```bash
sudo apt install libfuse2
```

---

## 2. Running the app

1. Make the AppImage executable:
   ```bash
   chmod +x FileFlow-x86_64.AppImage
   ```
2. Run it:
   ```bash
   ./FileFlow-x86_64.AppImage
   ```

The app will launch and minimize to your system tray. If you don't see a tray icon appear, see Section 3 below — this is the most common snag.

---

## 3. Tray icon support (varies by desktop environment)

Not all desktop environments show a tray icon by default. What you need depends on what you're running:

### GNOME (Arch, Debian, Ubuntu, Fedora, etc.)
GNOME has **no tray by default**. You need the **AppIndicator extension**:

```bash
# Arch:
sudo pacman -S gnome-shell-extension-appindicator

# Debian/Ubuntu:
sudo apt install gnome-shell-extension-appindicator
```

Then enable it:
```bash
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
```

**If it still doesn't show up after enabling:** check whether extensions are globally disabled:
```bash
gsettings get org.gnome.shell disable-user-extensions
```
If this returns `true`, fix it with:
```bash
gsettings set org.gnome.shell disable-user-extensions false
```
This applies live — no restart needed. (But if this is the *first time* the extension is installed, GNOME Shell may need a full logout/login to detect it at all — there's no live-reload on Wayland like there was on X11.)

### Hyprland
Hyprland has **no built-in tray**. You need a status bar that supports one — **Waybar** is the standard choice:

```bash
# Arch:
sudo pacman -S waybar

# Debian/Ubuntu:
sudo apt install waybar
```

Add a `tray` module to your Waybar config (`~/.config/waybar/config`) if it's not already there, then restart Waybar.

### Other setups (KDE, XFCE, Cinnamon, etc.)
These generally have a tray built in — no extra steps should be needed.

---

## 4. Autostart on login (optional)

To have FileFlow launch automatically when you log in:

### GNOME / most desktop environments
Create a `.desktop` file at `~/.config/autostart/fileflow.desktop`:

```ini
[Desktop Entry]
Type=Application
Name=FileFlow
Exec=/full/path/to/FileFlow-x86_64.AppImage
X-GNOME-Autostart-enabled=true
```
Replace `/full/path/to/` with wherever you placed the AppImage.

### Hyprland
The XDG autostart file above **may not be honored** by Hyprland. The more reliable method is adding a line directly to your Hyprland config (`~/.config/hypr/hyprland.conf`):

```
exec-once = /full/path/to/FileFlow-x86_64.AppImage
```

---

## 5. Troubleshooting

| Problem | Likely cause |
|---|---|
| AppImage won't run at all | Missing `libfuse2` — see Section 1 |
| No tray icon appears | See Section 3 for your desktop environment |
| App doesn't autostart on login | See Section 4 — Hyprland users especially need the `exec-once` method |
| Uploads fail | Check Settings (gear icon in the app) — confirm the backend URL and API key are correct |

---

## 6. Settings

FileFlow's backend URL and API key can be changed from within the app: click the **gear icon** in the top-right corner. Changes are saved automatically and persist across restarts.
