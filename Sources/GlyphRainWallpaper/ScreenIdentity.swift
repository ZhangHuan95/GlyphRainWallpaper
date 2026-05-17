import AppKit

enum ScreenIdentity {
    static func id(for screen: NSScreen) -> String {
        if let number = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber {
            return "display-\(number.uint32Value)"
        }
        return "frame-\(Int(screen.frame.origin.x))-\(Int(screen.frame.origin.y))-\(Int(screen.frame.width))x\(Int(screen.frame.height))"
    }

    static func name(for screen: NSScreen, language: AppLanguage) -> String {
        let size = screen.frame.size
        let scale = screen.backingScaleFactor
        let width = Int(size.width * scale)
        let height = Int(size.height * scale)

        if screen == NSScreen.main {
            return "\(language.text(.mainDisplay)) (\(width)x\(height))"
        }
        return "\(language.text(.display)) \(width)x\(height)"
    }
}
