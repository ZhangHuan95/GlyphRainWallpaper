# Glyph Rain Wallpaper

把桌面变成一场有呼吸感的字雨。

Glyph Rain Wallpaper 是一个 macOS 动态壁纸应用。它不是简单地把字符随机洒满屏幕，而是用稳定的文字网格、流动的亮度波和多套科幻配色，让桌面像一块正在运行的未来显示器。

[在线演示 / Live demo](https://zhanghuan95.github.io/GlyphRainWallpaper/)

![Glyph Rain theme switching demo](docs/assets/theme-switching.gif)

## 为什么会好看

字符不会乱跳。每个字会先留在自己的格子里，等一束光完整经过后再悄悄刷新，所以画面有速度感，但不会碎。

颜色不是简单换皮。初号机、黑客帝国、RX-78、扎古、夏亚、ν 高达、独角兽等主题都有自己的底色、拖尾、高光和点缀色，切换时更像换了一套场景灯光。

它也不会抢你的鼠标。壁纸窗口贴在桌面层，不接管点击，只负责安静地发光。

## 适合谁

- 想让 Mac 桌面更有赛博感的人
- 喜欢文字雨、机甲配色、终端美学的人
- 想要一个轻量、原生、常驻菜单栏的动态壁纸工具的人

English: Glyph Rain Wallpaper is a macOS menu bar live wallpaper that turns your desktop into a stable, cinematic glyph-rain display with sci-fi color themes.

## 下载

从 Releases 下载最新版本：

[下载最新版本 / Download latest release](https://github.com/ZhangHuan95/GlyphRainWallpaper/releases/latest)

需要 macOS 13 或更新版本。

## 从源码构建

```sh
chmod +x Scripts/build-app.sh
Scripts/build-app.sh
open dist/GlyphRainWallpaper.app
```

需要 Swift 6 toolchain 或 Xcode Command Line Tools。

## 在线演示

静态演示页位于 `docs/index.html`，GitHub Pages 从 `main` 分支的 `/docs` 目录发布：

[https://zhanghuan95.github.io/GlyphRainWallpaper/](https://zhanghuan95.github.io/GlyphRainWallpaper/)
