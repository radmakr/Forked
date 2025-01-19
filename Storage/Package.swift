// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Storage",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .macCatalyst(.v17),
        .watchOS(.v10),
        .tvOS(.v17),
    ],
    products: [
        .library(
            name: "Storage",
            targets: ["Storage"]),
    ],
    targets: [
        .target(
            name: "Storage"),
        .testTarget(
            name: "StorageTests",
            dependencies: ["Storage"]
        ),
    ]
)
