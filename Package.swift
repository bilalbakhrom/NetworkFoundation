// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkFoundation",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
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
 
