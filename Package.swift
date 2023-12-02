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
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "NotionSwift",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged")
            ]
        ),
        .testTarget(
            name: "NotionSwiftTests",
            dependencies: ["NotionSwift"]
        ),
    ]
)
