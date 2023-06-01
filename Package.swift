// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkFoundation",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "NetworkFoundation",
            targets: ["NetworkFoundation"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NetworkFoundation",
            dependencies: []),
        .testTarget(
            name: "NetworkFoundationTests",
            dependencies: ["NetworkFoundation"]),
    ]
)
