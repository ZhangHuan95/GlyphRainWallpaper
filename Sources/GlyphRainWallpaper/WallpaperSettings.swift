import Foundation

enum WallpaperSettingKey: String {
    case speed
    case density
    case textScale
    case brightness
    case glow
    case glowLength
}

enum ColorPreset: String, CaseIterable, Codable {
    case unit01
    case terminal
    case alert
    case rx78 = "nerv"
    case zaku = "lcl"
    case char = "moonlight"
    case nu = "berserk"
    case unicorn = "stealth"

    func displayName(language: AppLanguage) -> String {
        switch self {
        case .unit01: language.text(.presetUnit01)
        case .terminal: language.text(.presetTerminal)
        case .alert: language.text(.presetAlert)
        case .rx78: language.text(.presetRX78)
        case .zaku: language.text(.presetZaku)
        case .char: language.text(.presetChar)
        case .nu: language.text(.presetNu)
        case .unicorn: language.text(.presetUnicorn)
        }
    }

    func story(language: AppLanguage) -> String {
        switch self {
        case .unit01: language.text(.presetStoryUnit01)
        case .terminal: language.text(.presetStoryTerminal)
        case .alert: language.text(.presetStoryAlert)
        case .rx78: language.text(.presetStoryRX78)
        case .zaku: language.text(.presetStoryZaku)
        case .char: language.text(.presetStoryChar)
        case .nu: language.text(.presetStoryNu)
        case .unicorn: language.text(.presetStoryUnicorn)
        }
    }

    var payload: [String: String] {
        switch self {
        case .unit01:
            [
                "background": "#030108",
                "trail": "#4b1b84",
                "head": "#9dff2f",
                "accent": "#ff7a18",
                "magenta": "#ff2bd6"
            ]
        case .terminal:
            [
                "background": "#020403",
                "trail": "#005f2f",
                "head": "#aaffbf",
                "accent": "#35ff6d",
                "magenta": "#88ffcc"
            ]
        case .alert:
            [
                "background": "#090105",
                "trail": "#6d184d",
                "head": "#d5ff36",
                "accent": "#ff4b13",
                "magenta": "#ff2bd6"
            ]
        case .rx78:
            [
                "background": "#020510",
                "trail": "#2457b8",
                "head": "#f7fbff",
                "accent": "#e41f26",
                "magenta": "#ffd43a"
            ]
        case .zaku:
            [
                "background": "#020701",
                "trail": "#24451d",
                "head": "#b8f084",
                "accent": "#6b8f3a",
                "magenta": "#ff5f4d"
            ]
        case .char:
            [
                "background": "#080102",
                "trail": "#8e1d2c",
                "head": "#ffd1cb",
                "accent": "#ff334e",
                "magenta": "#ffb347"
            ]
        case .nu:
            [
                "background": "#010309",
                "trail": "#132b57",
                "head": "#f6f0cf",
                "accent": "#ffcc2e",
                "magenta": "#6d8cff"
            ]
        case .unicorn:
            [
                "background": "#020204",
                "trail": "#7a1224",
                "head": "#ffffff",
                "accent": "#ff174c",
                "magenta": "#42f5ff"
            ]
        }
    }
}

struct WallpaperSettings: Codable {
    private static let defaultSpeed = 0.6722222222
    private static let defaultDensity = 1.8111111111
    private static let defaultTextScale = 1.1444444444
    private static let defaultBrightness = 0.8666666667
    private static let defaultGlow = 1.1
    private static let defaultGlowLength = 20.0

    var speed: Double = Self.defaultSpeed
    var density: Double = Self.defaultDensity
    var textScale: Double = Self.defaultTextScale
    var brightness: Double = Self.defaultBrightness
    var glow: Double = Self.defaultGlow
    var glowLength: Double = Self.defaultGlowLength
    var isPaused: Bool = false
    var launchAtLogin: Bool = false
    var language: AppLanguage = .system
    var preset: ColorPreset = .unit01
    var disabledScreenIDs: Set<String> = []

    mutating func resetVisualSettings() {
        speed = Self.defaultSpeed
        density = Self.defaultDensity
        textScale = Self.defaultTextScale
        brightness = Self.defaultBrightness
        glow = Self.defaultGlow
        glowLength = Self.defaultGlowLength
        preset = .unit01
        isPaused = false
    }

    enum CodingKeys: String, CodingKey {
        case speed
        case density
        case textScale
        case brightness
        case glow
        case glowLength
        case isPaused
        case launchAtLogin
        case language
        case preset
        case disabledScreenIDs
    }

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try container.decodeIfPresent(Double.self, forKey: .speed) ?? Self.defaultSpeed
        density = try container.decodeIfPresent(Double.self, forKey: .density) ?? Self.defaultDensity
        textScale = try container.decodeIfPresent(Double.self, forKey: .textScale) ?? Self.defaultTextScale
        brightness = try container.decodeIfPresent(Double.self, forKey: .brightness) ?? Self.defaultBrightness
        glow = try container.decodeIfPresent(Double.self, forKey: .glow) ?? Self.defaultGlow
        glowLength = try container.decodeIfPresent(Double.self, forKey: .glowLength) ?? Self.defaultGlowLength
        isPaused = try container.decodeIfPresent(Bool.self, forKey: .isPaused) ?? false
        launchAtLogin = try container.decodeIfPresent(Bool.self, forKey: .launchAtLogin) ?? false
        language = try container.decodeIfPresent(AppLanguage.self, forKey: .language) ?? .system
        preset = try container.decodeIfPresent(ColorPreset.self, forKey: .preset) ?? .unit01
        disabledScreenIDs = try container.decodeIfPresent(Set<String>.self, forKey: .disabledScreenIDs) ?? []
    }

    func value(for key: WallpaperSettingKey) -> Double {
        switch key {
        case .speed: speed
        case .density: density
        case .textScale: textScale
        case .brightness: brightness
        case .glow: glow
        case .glowLength: glowLength
        }
    }

    mutating func setValue(_ value: Double, for key: WallpaperSettingKey) {
        switch key {
        case .speed: speed = value
        case .density: density = value
        case .textScale: textScale = value
        case .brightness: brightness = value
        case .glow: glow = value
        case .glowLength: glowLength = value
        }
    }

    var javaScriptPayload: String {
        let payload: [String: Any] = [
            "speed": speed,
            "density": density,
            "textScale": textScale,
            "brightness": brightness,
            "glow": glow,
            "glowLength": glowLength,
            "paused": isPaused,
            "preset": preset.payload,
            "targetPresets": [
                ["label": "4K 16:9", "width": 3840, "height": 2160],
                ["label": "MacBook Pro 16", "width": 3456, "height": 2234],
                ["label": "MacBook Pro 14", "width": 3024, "height": 1964]
            ]
        ]

        guard
            let data = try? JSONSerialization.data(withJSONObject: payload),
            let json = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }

        return json
    }
}

final class WallpaperSettingsStore {
    private let key = "GlyphRainWallpaper.settings.v1"
    private let defaults: UserDefaults

    var values: WallpaperSettings

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if
            let data = defaults.data(forKey: key),
            let decoded = try? JSONDecoder().decode(WallpaperSettings.self, from: data)
        {
            values = decoded
        } else {
            values = WallpaperSettings()
        }
        migrateLegacyValuesIfNeeded()
    }

    func save() {
        guard let data = try? JSONEncoder().encode(values) else { return }
        defaults.set(data, forKey: key)
    }

    private func migrateLegacyValuesIfNeeded() {
        var changed = false

        switch values.speed {
        case 1.34...1.36:
            values.speed = 0.42
            changed = true
        case 2.19...2.21:
            values.speed = 0.72
            changed = true
        case 3.09...3.11:
            values.speed = 1.08
            changed = true
        case 1.2...:
            values.speed = 0.72
            changed = true
        default:
            break
        }

        switch values.density {
        case 0.79...0.81:
            values.density = 1.25
            changed = true
        case 1.14...1.16:
            values.density = 1.65
            changed = true
        case 1.44...1.46:
            values.density = 2.05
            changed = true
        default:
            break
        }

        if values.glowLength < 19.01 {
            values.glowLength = 20.0
            changed = true
        }

        if changed {
            save()
        }
    }
}
