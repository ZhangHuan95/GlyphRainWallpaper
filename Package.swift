// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "GlyphRainWallpaper",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "GlyphRainWallpaper", targets: ["GlyphRainWallpaper"])
    ],
    targets: [
        .executableTarget(
            name: "GlyphRainWallpaper",
            resources: [
                .process("Resources")
            ],
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("WebKit"),
                .linkedFramework("ServiceManagement")
            ]
        )
    ]
)
