// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PimineSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Pimine-Utilities",
            targets: ["Utilities"]
        ),
        
        .library(
            name: "Pimine-Concurrency",
            targets: ["Concurrency"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Utilities",
            path: "Utilities",
            sources: [
                "Utilities"
            ]
        ),
        
        .target(
            name: "Concurrency",
            path: "Concurrency"
        )
    ]
)
