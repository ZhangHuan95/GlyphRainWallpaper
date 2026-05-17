import Foundation

enum AppLanguage: String, CaseIterable, Codable {
    case system
    case english
    case simplifiedChinese
    case japanese

    var displayName: String {
        switch self {
        case .system: text(.languageSystem)
        case .english: "English"
        case .simplifiedChinese: "简体中文"
        case .japanese: "日本語"
        }
    }

    private var resolved: AppLanguage {
        switch self {
        case .system:
            let preferred = Locale.preferredLanguages.first?.lowercased() ?? "en"
            if preferred.hasPrefix("zh") {
                return .simplifiedChinese
            }
            if preferred.hasPrefix("ja") {
                return .japanese
            }
            return .english
        default:
            return self
        }
    }

    func text(_ key: L10nKey) -> String {
        L10n.table[key]?[resolved] ?? L10n.table[key]?[.english] ?? key.rawValue
    }
}

enum L10nKey: String {
    case appTitle
    case menuBarTitle
    case pause
    case resume
    case colorPreset
    case speed
    case speedCalm
    case speedFast
    case speedBerserk
    case density
    case densitySparse
    case densityDense
    case densityOverdrive
    case textSize
    case textSizeSmall
    case textSizeNormal
    case textSizeLarge
    case brightness
    case brightnessDeskFriendly
    case brightnessNeon
    case brightnessLuminous
    case glow
    case glowLength
    case glowTight
    case glowUnit01
    case glowAngelAlert
    case screens
    case mainDisplay
    case display
    case openAtLogin
    case language
    case languageSystem
    case rebuildWindows
    case resetDefaults
    case quit
    case launchErrorTitle
    case presetUnit01
    case presetTerminal
    case presetAlert
    case presetRX78
    case presetZaku
    case presetChar
    case presetNu
    case presetUnicorn
    case presetStoryUnit01
    case presetStoryTerminal
    case presetStoryAlert
    case presetStoryRX78
    case presetStoryZaku
    case presetStoryChar
    case presetStoryNu
    case presetStoryUnicorn
}

enum L10n {
    static let table: [L10nKey: [AppLanguage: String]] = [
        .appTitle: [
            .english: "Glyph Rain Wallpaper",
            .simplifiedChinese: "字雨动态壁纸",
            .japanese: "文字雨ライブ壁紙"
        ],
        .menuBarTitle: [
            .english: "Glyph Rain",
            .simplifiedChinese: "字雨",
            .japanese: "文字雨"
        ],
        .pause: [
            .english: "Freeze Current Frame",
            .simplifiedChinese: "定格当前画面",
            .japanese: "現在の画面で停止"
        ],
        .resume: [
            .english: "Start Moving Again",
            .simplifiedChinese: "继续流动",
            .japanese: "流れを再開"
        ],
        .colorPreset: [
            .english: "Color Style",
            .simplifiedChinese: "颜色风格",
            .japanese: "色の雰囲気"
        ],
        .speed: [
            .english: "Text Fall Speed",
            .simplifiedChinese: "文字下落速度",
            .japanese: "文字の落下速度"
        ],
        .speedCalm: [
            .english: "Slow",
            .simplifiedChinese: "慢速",
            .japanese: "ゆっくり"
        ],
        .speedFast: [
            .english: "Normal",
            .simplifiedChinese: "标准",
            .japanese: "標準"
        ],
        .speedBerserk: [
            .english: "Fast",
            .simplifiedChinese: "快速",
            .japanese: "速い"
        ],
        .density: [
            .english: "Number of Text Columns",
            .simplifiedChinese: "文字列数量",
            .japanese: "文字列の本数"
        ],
        .densitySparse: [
            .english: "Fewer Columns",
            .simplifiedChinese: "少一些",
            .japanese: "少なめ"
        ],
        .densityDense: [
            .english: "More Columns",
            .simplifiedChinese: "多一些",
            .japanese: "多め"
        ],
        .densityOverdrive: [
            .english: "Very Many Columns",
            .simplifiedChinese: "很多列",
            .japanese: "かなり多い"
        ],
        .textSize: [
            .english: "Text Size",
            .simplifiedChinese: "文字大小",
            .japanese: "文字サイズ"
        ],
        .textSizeSmall: [
            .english: "Smaller Text",
            .simplifiedChinese: "小字",
            .japanese: "小さめ"
        ],
        .textSizeNormal: [
            .english: "Normal Text",
            .simplifiedChinese: "标准",
            .japanese: "標準"
        ],
        .textSizeLarge: [
            .english: "Larger Text",
            .simplifiedChinese: "大字",
            .japanese: "大きめ"
        ],
        .brightness: [
            .english: "Overall Brightness",
            .simplifiedChinese: "整体亮度",
            .japanese: "全体の明るさ"
        ],
        .brightnessDeskFriendly: [
            .english: "Dim",
            .simplifiedChinese: "暗一点",
            .japanese: "暗め"
        ],
        .brightnessNeon: [
            .english: "Normal",
            .simplifiedChinese: "标准",
            .japanese: "標準"
        ],
        .brightnessLuminous: [
            .english: "Bright",
            .simplifiedChinese: "亮一些",
            .japanese: "明るめ"
        ],
        .glow: [
            .english: "Halo Intensity",
            .simplifiedChinese: "光晕强度",
            .japanese: "光輪の強さ"
        ],
        .glowLength: [
            .english: "Bright Tail Length",
            .simplifiedChinese: "发光文字长度",
            .japanese: "光る文字の長さ"
        ],
        .glowTight: [
            .english: "Less Glow",
            .simplifiedChinese: "少一点",
            .japanese: "弱め"
        ],
        .glowUnit01: [
            .english: "Normal Glow",
            .simplifiedChinese: "标准",
            .japanese: "標準"
        ],
        .glowAngelAlert: [
            .english: "Strong Glow",
            .simplifiedChinese: "强一点",
            .japanese: "強め"
        ],
        .screens: [
            .english: "Screens",
            .simplifiedChinese: "屏幕",
            .japanese: "ディスプレイ"
        ],
        .mainDisplay: [
            .english: "Main Display",
            .simplifiedChinese: "主屏幕",
            .japanese: "メインディスプレイ"
        ],
        .display: [
            .english: "Display",
            .simplifiedChinese: "屏幕",
            .japanese: "ディスプレイ"
        ],
        .openAtLogin: [
            .english: "Start Automatically After Login",
            .simplifiedChinese: "登录后自动启动",
            .japanese: "ログイン後に自動起動"
        ],
        .language: [
            .english: "Language",
            .simplifiedChinese: "语言",
            .japanese: "言語"
        ],
        .languageSystem: [
            .english: "Follow System Language",
            .simplifiedChinese: "跟随系统",
            .japanese: "システム言語に合わせる"
        ],
        .rebuildWindows: [
            .english: "Refresh Wallpaper Windows",
            .simplifiedChinese: "刷新壁纸窗口",
            .japanese: "壁紙ウィンドウを更新"
        ],
        .resetDefaults: [
            .english: "Reset Visual Settings",
            .simplifiedChinese: "恢复默认视觉设置",
            .japanese: "見た目の設定をリセット"
        ],
        .quit: [
            .english: "Quit",
            .simplifiedChinese: "退出",
            .japanese: "終了"
        ],
        .launchErrorTitle: [
            .english: "Open at Login could not be changed",
            .simplifiedChinese: "无法更改登录时打开设置",
            .japanese: "ログイン時に開く設定を変更できません"
        ],
        .presetUnit01: [
            .english: "Unit-01 Purple/Green",
            .simplifiedChinese: "初号机紫绿",
            .japanese: "初号機 パープル/グリーン"
        ],
        .presetTerminal: [
            .english: "Classic Terminal",
            .simplifiedChinese: "经典终端",
            .japanese: "クラシック端末"
        ],
        .presetAlert: [
            .english: "Angel Alert",
            .simplifiedChinese: "使徒警报",
            .japanese: "使徒警報"
        ],
        .presetRX78: [
            .english: "RX-78 White/Blue",
            .simplifiedChinese: "RX-78 白蓝红",
            .japanese: "RX-78 ホワイト/ブルー"
        ],
        .presetZaku: [
            .english: "Zaku Green",
            .simplifiedChinese: "扎古军绿",
            .japanese: "ザク グリーン"
        ],
        .presetChar: [
            .english: "Char Red",
            .simplifiedChinese: "夏亚红",
            .japanese: "シャア レッド"
        ],
        .presetNu: [
            .english: "Nu Gundam Navy",
            .simplifiedChinese: "ν 高达海军蓝",
            .japanese: "νガンダム ネイビー"
        ],
        .presetUnicorn: [
            .english: "Unicorn Psycho-Frame",
            .simplifiedChinese: "独角兽精神感应框架",
            .japanese: "ユニコーン サイコフレーム"
        ],
        .presetStoryUnit01: [
            .english: "Unit-01 awakening: purple armor, green signal text, orange emergency sparks.",
            .simplifiedChinese: "初号机觉醒：紫色装甲、荧光绿信号文字、橙色警报火花。",
            .japanese: "初号機覚醒: 紫の装甲、緑の信号文字、オレンジの警報火花。"
        ],
        .presetStoryTerminal: [
            .english: "Old terminal room: black screen, phosphor green text, mint afterglow.",
            .simplifiedChinese: "老式终端室：黑底、磷光绿字符、薄荷色余辉。",
            .japanese: "古い端末室: 黒い画面、蛍光グリーン文字、ミント残光。"
        ],
        .presetStoryAlert: [
            .english: "Angel contact alarm: red-purple pressure, acid yellow heads, orange flashes.",
            .simplifiedChinese: "使徒接触警报：红紫压迫、酸黄头字、橙色冲击警示。",
            .japanese: "使徒接触警報: 赤紫の圧力、酸性イエロー、オレンジ警告。"
        ],
        .presetStoryRX78: [
            .english: "RX-78 launch: white armor, Federation blue trails, red/yellow hero marks.",
            .simplifiedChinese: "RX-78 出击：白色装甲、联邦蓝拖尾、红黄主角机标识。",
            .japanese: "RX-78 出撃: 白い装甲、連邦ブルー、赤黄の主役機マーク。"
        ],
        .presetStoryZaku: [
            .english: "Zaku patrol: olive armor, dim military trails, mono-eye warning red.",
            .simplifiedChinese: "扎古巡逻：橄榄装甲、暗军用拖尾、单眼红威胁信号。",
            .japanese: "ザク哨戒: オリーブ装甲、暗い軍用軌跡、モノアイ警告レッド。"
        ],
        .presetStoryChar: [
            .english: "Char custom: crimson armor, pale speed glow, gold ace-pilot flashes.",
            .simplifiedChinese: "夏亚专用：深红装甲、淡粉速度光、金色王牌机闪光。",
            .japanese: "シャア専用: 深紅装甲、淡い速度光、金色のエース機フラッシュ。"
        ],
        .presetStoryNu: [
            .english: "Nu command space: black/navy silhouette, warm white armor, yellow funnels.",
            .simplifiedChinese: "ν 指挥空间：黑蓝剪影、暖白装甲、黄色浮游炮信号。",
            .japanese: "ν 指揮空間: 黒紺の影、暖白装甲、黄色ファンネル信号。"
        ],
        .presetStoryUnicorn: [
            .english: "Unicorn NT-D: white armor, red psycho-frame glow, cyan data noise.",
            .simplifiedChinese: "独角兽 NT-D：纯白装甲、红色精神骨架、青色数据噪声。",
            .japanese: "ユニコーン NT-D: 白い装甲、赤いサイコフレーム、シアンノイズ。"
        ]
    ]
}
