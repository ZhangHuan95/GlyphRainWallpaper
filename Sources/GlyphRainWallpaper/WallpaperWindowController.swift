import AppKit
import WebKit

@MainActor
final class WallpaperWindowController: NSWindowController {
    private var screenID: String
    private let rendererView: RendererView

    init(screen: NSScreen, settings: WallpaperSettings) {
        screenID = ScreenIdentity.id(for: screen)
        rendererView = RendererView(settings: settings)

        let window = WallpaperWindow(screen: screen)
        window.contentView = rendererView
        super.init(window: window)
        apply(settings: settings)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(screen: NSScreen, settings: WallpaperSettings) {
        screenID = ScreenIdentity.id(for: screen)
        guard let window = window else { return }
        window.setFrame(screen.frame, display: true)
        apply(settings: settings)
    }

    func show() {
        window?.orderFrontRegardless()
    }

    func apply(settings: WallpaperSettings) {
        rendererView.apply(settings: settings)
    }
}

final class WallpaperWindow: NSWindow {
    init(screen: NSScreen) {
        super.init(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        isReleasedWhenClosed = false
        backgroundColor = .black
        isOpaque = true
        hasShadow = false
        ignoresMouseEvents = true
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenAuxiliary]
        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)) - 1)
        animationBehavior = .none
        title = "Glyph Rain Wallpaper"
    }

    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}

@MainActor
final class RendererView: NSView, WKNavigationDelegate {
    private let webView: WKWebView
    private var pendingSettings: WallpaperSettings?
    private var didFinishLoading = false

    init(settings: WallpaperSettings) {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true

        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        webView = WKWebView(frame: .zero, configuration: configuration)
        pendingSettings = settings

        super.init(frame: .zero)

        wantsLayer = true
        layer?.backgroundColor = NSColor.black.cgColor

        webView.navigationDelegate = self
        webView.setValue(false, forKey: "drawsBackground")
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        loadRenderer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(settings: WallpaperSettings) {
        pendingSettings = settings
        guard didFinishLoading else { return }
        push(settings: settings)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didFinishLoading = true
        if let pendingSettings {
            push(settings: pendingSettings)
        }
    }

    private func loadRenderer() {
        guard let url = Bundle.module.url(forResource: "renderer", withExtension: "html") else {
            assertionFailure("renderer.html missing from bundle resources")
            return
        }
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }

    private func push(settings: WallpaperSettings) {
        let script = "window.GlyphRainWallpaper && window.GlyphRainWallpaper.applySettings(\(settings.javaScriptPayload));"
        webView.evaluateJavaScript(script)
    }
}
