// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotionSwift",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0"),
    ],
    products: [
        .library(
            name: "NotionSwift",
            targets: ["NotionSwift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NotionSwift",
            dependencies: []
        ),
        .testTarget(
            name: "NotionSwiftTests",
            dependencies: ["NotionSwift"]
        ),
    ]
)
