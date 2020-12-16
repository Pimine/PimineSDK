// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PimineSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Pimine-Concurrency",
            targets: ["Concurrency"]),
    ],
    dependencies: [],
    targets: [
        
        .target(
            name: "Concurrency",
            path: "Concurrency",
            exclude: [
                "Support files/Info.plist"
            ]
        )
    ]
)
