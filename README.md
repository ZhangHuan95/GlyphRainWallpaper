# Glyph Rain Wallpaper / 字雨动态壁纸

一个 macOS 菜单栏动态壁纸应用，用固定字符网格、流动亮度波和多套科幻配色生成高密度文字雨。

A macOS menu bar wallpaper app that renders high-intensity character rain with fixed glyph grids, flowing brightness waves, and multiple sci-fi color themes.

[在线演示 / Live demo](https://zhanghuan95.github.io/GlyphRainWallpaper/)

![Glyph Rain theme switching demo](docs/assets/theme-switching.gif)

Glyph Rain 会把桌面变成可调节的文字雨表面。每块屏幕会被拆成稳定的文字格子：雨阵经过时只改变亮度、颜色、光晕和发光长度；每个格子的字符会保持不动，直到当前雨尾完全离开后才刷新。

Glyph Rain turns the desktop into a configurable character-rain surface. Each screen is divided into stable text cells: the rain passes through by changing brightness, color, halo, and tail length, while the glyph in each cell stays fixed until the current rain streak has fully moved past it.

## 功能亮点 / Highlights

- 固定字符网格渲染：雨阵经过时字符不乱跳，只改变亮度和色彩。
- Fixed glyph-grid renderer: characters stay stable while the rain wave passes through.
- 8 套带有角色/场景设定的配色，包括初号机、黑客帝国、RX-78、扎古、夏亚、ν 高达和独角兽风格。
- Eight story-driven color themes, including Unit-01, Matrix, RX-78, Zaku, Char, Nu Gundam, and Unicorn-inspired palettes.
- 10 档控制：下落速度、文字列数量、文字大小、整体亮度、光晕强度、发光文字长度。
- 10-step controls for speed, column count, text size, brightness, halo intensity, and bright tail length.
- 原生 macOS 菜单栏应用，为每块启用的屏幕创建一个壁纸窗口。
- Native macOS menu bar app with one wallpaper window per active display.
- Canvas 渲染器嵌入 `WKWebView`，支持 Retina 自适应缩放。
- Canvas renderer embedded in `WKWebView`, with Retina-aware scaling.

## 环境要求 / Requirements

- macOS 13 或更新版本 / macOS 13 or newer
- Swift 6 toolchain / Xcode Command Line Tools

## 构建 / Build

```sh
chmod +x Scripts/build-app.sh
Scripts/build-app.sh
```

构建完成后，App 会生成在：

The app bundle is created at:

```text
dist/GlyphRainWallpaper.app
```

运行：

Run it with:

```sh
open dist/GlyphRainWallpaper.app
```

## 控制项 / Controls

通过菜单栏里的 `Glyph Rain` 可以暂停/继续动画、选择颜色风格、调节速度、文字列数量、字号、整体亮度、光晕强度、发光文字长度，启用或禁用屏幕，刷新壁纸窗口，以及退出应用。

Use the `Glyph Rain` menu bar item to pause/resume animation, choose color presets, adjust speed, density, text size, brightness, halo, bright tail length, enable or disable displays, rebuild wallpaper windows, and quit.

壁纸窗口会忽略鼠标事件，并为每块启用的屏幕创建一个无边框窗口。

The wallpaper ignores mouse events and creates one borderless window per active screen.

## GitHub Pages 演示 / GitHub Pages Demo

[在线打开演示 / Open the live demo](https://zhanghuan95.github.io/GlyphRainWallpaper/)

静态演示页位于 `docs/index.html`，GitHub Pages 已配置为从 `main` 分支的 `/docs` 目录发布。

The static demo page lives in `docs/index.html`, and GitHub Pages is configured to publish from `/docs` on the `main` branch.
