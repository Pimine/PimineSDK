// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PimineSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Pimine-HandyExtensions",
            targets: ["HandyExtensions"]
        ),
        
        .library(
            name: "Pimine-Utilities",
            targets: ["Utilities"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwifterSwift/SwifterSwift.git", from: "5.2.0")
    ],
    targets: [
        .target(
            name: "HandyExtensions",
            dependencies: ["SwifterSwift"],
            path: "HandyExtensions"
        ),
        
        .target(
            name: "Utilities",
            path: "Utilities"
        )
    ]
)
