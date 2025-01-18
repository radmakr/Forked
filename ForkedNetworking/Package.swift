// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ForkedNetworking",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .macCatalyst(.v17),
        .watchOS(.v10),
        .tvOS(.v17),
    ],
    products: [
        .library(
            name: "ForkedNetworking",
            targets: ["ForkedNetworking"]),
    ],
    targets: [
        .target(
            name: "ForkedNetworking"),
        .testTarget(
            name: "ForkedNetworkingTests",
            dependencies: ["ForkedNetworking"]
        ),
    ]
)
