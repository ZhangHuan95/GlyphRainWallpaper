# Glyph Rain Wallpaper

A macOS menu bar wallpaper app that renders high-intensity character rain with multiple sci-fi color themes.

## Requirements

- macOS 13 or newer
- Swift 6 toolchain / Xcode Command Line Tools

## Build

```sh
chmod +x Scripts/build-app.sh
Scripts/build-app.sh
```

The app bundle is created at:

```text
dist/GlyphRainWallpaper.app
```

Run it with:

```sh
open dist/GlyphRainWallpaper.app
```

## Controls

Use the `Glyph Rain` menu bar item to pause/resume animation, choose color presets, adjust speed, density, brightness, halo, bright tail length, enable or disable displays, rebuild wallpaper windows, and quit.

The wallpaper ignores mouse events and creates one borderless window per active screen.
