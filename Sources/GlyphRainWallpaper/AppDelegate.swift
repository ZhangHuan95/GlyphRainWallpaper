import AppKit
import ServiceManagement

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let settings = WallpaperSettingsStore()
    private var screenControllers: [String: WallpaperWindowController] = [:]
    private var screenMenuItems: [String: NSMenuItem] = [:]
    private var menusByKey: [WallpaperSettingKey: [NSMenuItem]] = [:]
    private var presetButtons: [PresetButton] = []
    private weak var presetStoryLabel: NSTextField?
    private var language: AppLanguage {
        settings.values.language
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        configureStatusItem()
        rebuildWallpapers(staggerSecondaryScreens: true)

        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(activeSpaceDidChange),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenParametersDidChange),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
    }

    func applicationWillTerminate(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self)
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }

    @objc private func activeSpaceDidChange() {
        for controller in screenControllers.values {
            controller.show()
        }
    }

    @objc private func screenParametersDidChange() {
        rebuildWallpapers(staggerSecondaryScreens: false)
        configureStatusItem()
    }

    private func configureStatusItem() {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "sparkles", accessibilityDescription: language.text(.appTitle))
            button.imagePosition = .imageLeading
            button.title = " \(language.text(.menuBarTitle))"
        }

        let menu = NSMenu()
        menu.addItem(makeTitleItem(language.text(.appTitle)))
        menu.addItem(.separator())

        let pauseItem = NSMenuItem(
            title: settings.values.isPaused ? language.text(.resume) : language.text(.pause),
            action: #selector(togglePaused),
            keyEquivalent: ""
        )
        pauseItem.target = self
        menu.addItem(pauseItem)

        menu.addItem(makeControlPanelItem())

        menu.addItem(.separator())
        let resetItem = NSMenuItem(title: language.text(.resetDefaults), action: #selector(resetDefaults), keyEquivalent: "")
        resetItem.target = self
        menu.addItem(resetItem)

        menu.addItem(makeScreensMenu())
        menu.addItem(makeLanguageMenu())

        let launchItem = NSMenuItem(title: language.text(.openAtLogin), action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        launchItem.target = self
        launchItem.state = settings.values.launchAtLogin ? .on : .off
        menu.addItem(launchItem)

        menu.addItem(.separator())
        let restartItem = NSMenuItem(title: language.text(.rebuildWindows), action: #selector(rebuildWallpapersAction), keyEquivalent: "r")
        restartItem.target = self
        menu.addItem(restartItem)

        let quitItem = NSMenuItem(title: language.text(.quit), action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    private func makeTitleItem(_ title: String) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    private func makePresetMenu() -> NSMenuItem {
        let item = NSMenuItem(title: language.text(.colorPreset), action: nil, keyEquivalent: "")
        let submenu = NSMenu()
        for preset in ColorPreset.allCases {
            let menuItem = NSMenuItem(title: preset.displayName(language: language), action: #selector(selectPreset(_:)), keyEquivalent: "")
            menuItem.target = self
            menuItem.representedObject = preset.rawValue
            menuItem.state = settings.values.preset == preset ? .on : .off
            submenu.addItem(menuItem)
        }
        item.submenu = submenu
        return item
    }

    private func makeControlPanelItem() -> NSMenuItem {
        let item = NSMenuItem()
        let panel = ControlPanelView(frame: NSRect(x: 0, y: 0, width: 620, height: 352))

        let colorLabel = NSTextField(labelWithString: language.text(.colorPreset))
        colorLabel.font = .systemFont(ofSize: 12, weight: .medium)
        colorLabel.frame = NSRect(x: 18, y: 12, width: 112, height: 22)

        panel.addSubview(colorLabel)
        panel.addSubview(makePresetGrid())
        panel.addSubview(makePresetStoryLabel())

        panel.addSubview(makePanelSliderRow(title: language.text(.speed), key: .speed, y: 132))
        panel.addSubview(makePanelSliderRow(title: language.text(.density), key: .density, y: 166))
        panel.addSubview(makePanelSliderRow(title: language.text(.textSize), key: .textScale, y: 200))
        panel.addSubview(makePanelSliderRow(title: language.text(.brightness), key: .brightness, y: 234))
        panel.addSubview(makePanelSliderRow(title: language.text(.glow), key: .glow, y: 268))
        panel.addSubview(makePanelSliderRow(title: language.text(.glowLength), key: .glowLength, y: 302))

        item.view = panel
        return item
    }

    private func makePresetGrid() -> NSView {
        let grid = ControlPanelView(frame: NSRect(x: 142, y: 10, width: 456, height: 72))
        let columnWidth: CGFloat = 108
        let gap: CGFloat = 8
        presetButtons.removeAll()

        for (index, preset) in ColorPreset.allCases.enumerated() {
            let column = index % 4
            let row = index / 4
            let button = PresetButton(title: preset.displayName(language: language), target: self, action: #selector(selectPresetButton(_:)))
            button.representedObject = preset.rawValue
            button.isSelectedPreset = settings.values.preset == preset
            button.setButtonType(.toggle)
            button.controlSize = .small
            button.font = .systemFont(ofSize: 11, weight: .medium)
            button.lineBreakMode = .byTruncatingTail
            button.state = settings.values.preset == preset ? .on : .off
            button.isBordered = false
            button.frame = NSRect(
                x: CGFloat(column) * (columnWidth + gap),
                y: CGFloat(row) * 32,
                width: columnWidth,
                height: 26
            )
            button.updateAppearance()
            grid.addSubview(button)
            presetButtons.append(button)
        }

        return grid
    }

    private func makePresetStoryLabel() -> NSTextField {
        let story = NSTextField(labelWithString: settings.values.preset.story(language: language))
        story.font = .systemFont(ofSize: 11)
        story.textColor = .secondaryLabelColor
        story.maximumNumberOfLines = 2
        story.lineBreakMode = .byTruncatingTail
        story.frame = NSRect(x: 142, y: 72, width: 456, height: 42)
        presetStoryLabel = story
        return story
    }

    private func makePanelSliderRow(title: String, key: WallpaperSettingKey, y: CGFloat) -> NSView {
        let level = settingLevel(for: key)
        let row = ControlPanelView(frame: NSRect(x: 18, y: y, width: 580, height: 30))

        let label = NSTextField(labelWithString: title)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .labelColor
        label.frame = NSRect(x: 0, y: 4, width: 126, height: 20)

        let valueLabel = NSTextField(labelWithString: "\(level)/10")
        valueLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        valueLabel.alignment = .right
        valueLabel.textColor = .secondaryLabelColor
        valueLabel.frame = NSRect(x: 532, y: 4, width: 48, height: 20)

        let slider = SettingSlider(value: Double(level), minValue: 1, maxValue: 10, target: self, action: #selector(sliderChanged(_:)))
        slider.settingKey = key
        slider.titlePrefix = title
        slider.valueLabel = valueLabel
        slider.valueLabelShowsValueOnly = true
        slider.numberOfTickMarks = 10
        slider.allowsTickMarkValuesOnly = true
        slider.isContinuous = true
        slider.controlSize = .small
        slider.frame = NSRect(x: 142, y: 3, width: 370, height: 22)

        row.addSubview(label)
        row.addSubview(slider)
        row.addSubview(valueLabel)
        return row
    }

    private func makeSettingMenu(title: String, key: WallpaperSettingKey, values: [SettingOption]) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        let submenu = NSMenu()
        menusByKey[key] = []

        for option in values {
            let menuItem = NSMenuItem(title: option.label, action: #selector(selectSetting(_:)), keyEquivalent: "")
            menuItem.target = self
            menuItem.representedObject = SettingSelection(key: key, value: option.value)
            menuItem.state = option.value.isNearlyEqual(to: settings.values.value(for: key)) ? .on : .off
            submenu.addItem(menuItem)
            menusByKey[key, default: []].append(menuItem)
        }

        item.submenu = submenu
        return item
    }

    private func makeSliderMenu(title: String, key: WallpaperSettingKey, lowLabel: String, highLabel: String) -> NSMenuItem {
        let level = settingLevel(for: key)
        let item = NSMenuItem(title: settingTitle(title: title, level: level), action: nil, keyEquivalent: "")
        let submenu = NSMenu()
        let sliderItem = NSMenuItem()

        let container = NSStackView(frame: NSRect(x: 0, y: 0, width: 260, height: 58))
        container.orientation = .vertical
        container.alignment = .leading
        container.spacing = 6
        container.edgeInsets = NSEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

        let label = NSTextField(labelWithString: "\(lowLabel)  ←  \(level)/10  →  \(highLabel)")
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabelColor
        label.lineBreakMode = .byTruncatingMiddle
        label.frame.size.width = 236

        let slider = SettingSlider(value: Double(level), minValue: 1, maxValue: 10, target: self, action: #selector(sliderChanged(_:)))
        slider.settingKey = key
        slider.parentMenuItem = item
        slider.titlePrefix = title
        slider.valueLabel = label
        slider.lowLabel = lowLabel
        slider.highLabel = highLabel
        slider.numberOfTickMarks = 10
        slider.allowsTickMarkValuesOnly = true
        slider.isContinuous = true
        slider.controlSize = .small
        slider.frame = NSRect(x: 0, y: 0, width: 236, height: 24)

        container.addArrangedSubview(label)
        container.addArrangedSubview(slider)
        sliderItem.view = container
        submenu.addItem(sliderItem)
        item.submenu = submenu
        return item
    }

    private func makeScreensMenu() -> NSMenuItem {
        let item = NSMenuItem(title: language.text(.screens), action: nil, keyEquivalent: "")
        let submenu = NSMenu()
        screenMenuItems.removeAll()

        for screen in NSScreen.screens {
            let id = ScreenIdentity.id(for: screen)
            let menuItem = NSMenuItem(title: ScreenIdentity.name(for: screen, language: language), action: #selector(toggleScreen(_:)), keyEquivalent: "")
            menuItem.target = self
            menuItem.representedObject = id
            menuItem.state = settings.values.disabledScreenIDs.contains(id) ? .off : .on
            submenu.addItem(menuItem)
            screenMenuItems[id] = menuItem
        }

        item.submenu = submenu
        return item
    }

    private func makeLanguageMenu() -> NSMenuItem {
        let item = NSMenuItem(title: language.text(.language), action: nil, keyEquivalent: "")
        let submenu = NSMenu()

        for appLanguage in AppLanguage.allCases {
            let menuItem = NSMenuItem(title: appLanguage.displayName, action: #selector(selectLanguage(_:)), keyEquivalent: "")
            menuItem.target = self
            menuItem.representedObject = appLanguage.rawValue
            menuItem.state = settings.values.language == appLanguage ? .on : .off
            submenu.addItem(menuItem)
        }

        item.submenu = submenu
        return item
    }

    @objc private func togglePaused() {
        settings.values.isPaused.toggle()
        settings.save()
        broadcastSettings()
        configureStatusItem()
    }

    @objc private func selectPreset(_ sender: NSMenuItem) {
        guard
            let rawValue = sender.representedObject as? String,
            let preset = ColorPreset(rawValue: rawValue)
        else { return }
        settings.values.preset = preset
        settings.save()
        refreshPresetControls()
        broadcastSettings()
    }

    private func refreshPresetControls() {
        for button in presetButtons {
            let isSelected = (button.representedObject as? String) == settings.values.preset.rawValue
            button.state = isSelected ? .on : .off
            button.isSelectedPreset = isSelected
        }
        presetStoryLabel?.stringValue = settings.values.preset.story(language: language)
    }

    @objc private func selectPresetPopup(_ sender: PresetPopupButton) {
        guard
            let rawValue = sender.selectedItem?.representedObject as? String,
            let preset = ColorPreset(rawValue: rawValue)
        else { return }
        settings.values.preset = preset
        settings.save()
        broadcastSettings()
    }

    @objc private func selectPresetSegment(_ sender: NSSegmentedControl) {
        let index = sender.selectedSegment
        guard ColorPreset.allCases.indices.contains(index) else { return }
        settings.values.preset = ColorPreset.allCases[index]
        settings.save()
        broadcastSettings()
    }

    @objc private func selectPresetButton(_ sender: PresetButton) {
        guard
            let rawValue = sender.representedObject as? String,
            let preset = ColorPreset(rawValue: rawValue)
        else { return }
        settings.values.preset = preset
        settings.save()
        refreshPresetControls()
        broadcastSettings()
    }

    @objc private func selectSetting(_ sender: NSMenuItem) {
        guard let selection = sender.representedObject as? SettingSelection else { return }
        settings.values.setValue(selection.value, for: selection.key)
        settings.save()
        broadcastSettings()
        configureStatusItem()
    }

    @objc private func sliderChanged(_ sender: SettingSlider) {
        guard let key = sender.settingKey else { return }
        let level = Int(round(sender.doubleValue)).clamped(to: 1...10)
        sender.doubleValue = Double(level)
        sender.parentMenuItem?.title = settingTitle(title: sender.titlePrefix, level: level)
        sender.valueLabel?.stringValue = sender.valueLabelShowsValueOnly ? "\(level)/10" : settingTitle(title: sender.titlePrefix, level: level)
        settings.values.setValue(settingValue(for: key, level: level), for: key)
        settings.save()
        broadcastSettings()
    }

    @objc private func selectLanguage(_ sender: NSMenuItem) {
        guard
            let rawValue = sender.representedObject as? String,
            let appLanguage = AppLanguage(rawValue: rawValue)
        else { return }
        settings.values.language = appLanguage
        settings.save()
        configureStatusItem()
    }

    @objc private func toggleScreen(_ sender: NSMenuItem) {
        guard let id = sender.representedObject as? String else { return }
        if settings.values.disabledScreenIDs.contains(id) {
            settings.values.disabledScreenIDs.remove(id)
        } else {
            settings.values.disabledScreenIDs.insert(id)
        }
        settings.save()
        rebuildWallpapers(staggerSecondaryScreens: false)
        configureStatusItem()
    }

    @objc private func toggleLaunchAtLogin() {
        settings.values.launchAtLogin.toggle()
        settings.save()

        if #available(macOS 13.0, *) {
            do {
                if settings.values.launchAtLogin {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                settings.values.launchAtLogin.toggle()
                settings.save()
                showLaunchAtLoginError(error)
            }
        }

        configureStatusItem()
    }

    @objc private func rebuildWallpapersAction() {
        rebuildWallpapers(staggerSecondaryScreens: false)
    }

    @objc private func resetDefaults() {
        settings.values.resetVisualSettings()
        settings.save()
        broadcastSettings()
        configureStatusItem()
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    private func rebuildWallpapers(staggerSecondaryScreens: Bool) {
        let currentIDs = Set(NSScreen.screens.map(ScreenIdentity.id(for:)))
        let expectedIDs = currentIDs.subtracting(settings.values.disabledScreenIDs)

        for (id, controller) in screenControllers where !expectedIDs.contains(id) {
            controller.close()
            screenControllers.removeValue(forKey: id)
        }

        for (index, screen) in NSScreen.screens.enumerated() {
            let id = ScreenIdentity.id(for: screen)
            guard !settings.values.disabledScreenIDs.contains(id) else { continue }

            if let controller = screenControllers[id] {
                controller.update(screen: screen, settings: settings.values)
                controller.show()
            } else {
                if staggerSecondaryScreens && index > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(180 * index)) { [weak self] in
                        guard let self, self.screenControllers[id] == nil else { return }
                        let controller = WallpaperWindowController(screen: screen, settings: self.settings.values)
                        self.screenControllers[id] = controller
                        controller.show()
                    }
                } else {
                    let controller = WallpaperWindowController(screen: screen, settings: settings.values)
                    screenControllers[id] = controller
                    controller.show()
                }
            }
        }
    }

    private func broadcastSettings() {
        for controller in screenControllers.values {
            controller.apply(settings: settings.values)
        }
    }

    private func settingLevel(for key: WallpaperSettingKey) -> Int {
        let range = settingRange(for: key)
        let value = settings.values.value(for: key)
        let ratio = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return Int(round(ratio * 9 + 1)).clamped(to: 1...10)
    }

    private func settingValue(for key: WallpaperSettingKey, level: Int) -> Double {
        let range = settingRange(for: key)
        let ratio = Double(level.clamped(to: 1...10) - 1) / 9
        return range.lowerBound + (range.upperBound - range.lowerBound) * ratio
    }

    private func settingRange(for key: WallpaperSettingKey) -> ClosedRange<Double> {
        switch key {
        case .speed:
            0.25...1.2
        case .density:
            0.7...3.2
        case .textScale:
            0.58...1.85
        case .brightness:
            0.2...1.7
        case .glow:
            0.1...2.35
        case .glowLength:
            12.0...30.0
        }
    }

    private func settingTitle(title: String, level: Int) -> String {
        "\(title): \(level)/10"
    }

    private func showLaunchAtLoginError(_ error: Error) {
        let alert = NSAlert()
        alert.messageText = language.text(.launchErrorTitle)
        alert.informativeText = error.localizedDescription
        alert.alertStyle = .warning
        alert.runModal()
    }
}

private struct SettingOption {
    let label: String
    let value: Double
}

private struct SettingSelection {
    let key: WallpaperSettingKey
    let value: Double
}

private final class SettingSlider: NSSlider {
    var settingKey: WallpaperSettingKey?
    weak var parentMenuItem: NSMenuItem?
    weak var valueLabel: NSTextField?
    var valueLabelShowsValueOnly = false
    var titlePrefix = ""
    var lowLabel = ""
    var highLabel = ""
}

private final class ControlPanelView: NSView {
    override var isFlipped: Bool { true }
}

private final class PresetButton: NSButton {
    var representedObject: Any?
    var isSelectedPreset = false {
        didSet { updateAppearance() }
    }

    func updateAppearance() {
        wantsLayer = true
        layer?.cornerRadius = 6
        layer?.borderWidth = isSelectedPreset ? 1.5 : 1
        layer?.borderColor = (isSelectedPreset ? NSColor.systemGreen : NSColor.separatorColor).cgColor
        layer?.backgroundColor = (isSelectedPreset ? NSColor.systemGreen.withAlphaComponent(0.18) : NSColor.controlBackgroundColor.withAlphaComponent(0.55)).cgColor

        let color = isSelectedPreset ? NSColor.labelColor : NSColor.secondaryLabelColor
        attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: color,
                .font: font ?? NSFont.systemFont(ofSize: 11, weight: .medium)
            ]
        )
    }
}

private final class PresetPopupButton: NSPopUpButton {}

private extension Double {
    func isNearlyEqual(to other: Double) -> Bool {
        abs(self - other) < 0.001
    }
}

private extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
