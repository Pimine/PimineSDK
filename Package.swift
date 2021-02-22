// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pimine",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Pimine",
            targets: ["Pimine"]
        ),
        
        .library(
            name: "PimineUtilities",
            targets: ["PimineUtilities"]
        ),
        
        .library(
            name: "PimineHandyExtensions",
            targets: ["PimineHandyExtensions"]
        ),
        
        .library(
            name: "PimineRevenueCatStore",
            targets: ["PimineRevenueCatStore"]
        ),
        
        .library(
            name: "PimineSwiftyStore",
            targets: ["PimineSwiftyStore"]
        ),
        
        .library(
            name: "PimineMath",
            targets: ["PimineMath"]
        ),
        
        .library(
            name: "PimineDatabase",
            targets: ["PimineDatabase"]
        ),
        
        .library(
            name: "PimineConcurrency",
            targets: ["PimineConcurrency"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwifterSwift/SwifterSwift.git", .upToNextMajor(from: "5.2.0")),
        .package(url: "https://github.com/sereivoanyong/SVProgressHUD", .branch("master")),
        .package(url: "https://github.com/bizz84/SwiftyStoreKit.git", .upToNextMajor(from: "0.16.1")),
        .package(name: "Purchases", url: "https://github.com/RevenueCat/purchases-ios.git", .upToNextMajor(from: "3.10.3")),
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa", .upToNextMajor(from: "10.6.0"))
    ],
    targets: [
        
        // Core
        
        .target(
            name: "Pimine",
            dependencies: [
                "PimineHandyExtensions",
                "PimineUtilities"
            ],
            path: "Pimine",
            exclude: ["Info.plist"]
        ),
        
        // Utilities
        
        .target(
            name: "PimineUtilities",
            path: "PimineUtilities",
            exclude: ["Support files/Info.plist"]
        ),
        
        // HandyExtensions
        
        .target(
            name: "PimineHandyExtensions",
            dependencies: [
                "PimineUtilities",
                "SwifterSwift"
            ],
            path: "PimineHandyExtensions",
            exclude: ["Support files/Info.plist"]
        ),
        
        // RevenueCatStore
        
        .target(
            name: "PimineRevenueCatStore",
            dependencies: [
                "PimineUtilities",
                "SVProgressHUD",
                "Purchases"
            ],
            path: "PimineRevenueCatStore",
            exclude: ["Support files/Info.plist"]
        ),
        
        // SwiftyStore
        
        .target(
            name: "PimineSwiftyStore",
            dependencies: [
                "PimineUtilities",
                "SVProgressHUD",
                "SwiftyStoreKit"
            ],
            path: "PimineSwiftyStore",
            exclude: ["Support files/Info.plist"]
        ),
        
        // Math
        
        .target(
            name: "PimineMath",
            path: "PimineMath",
            exclude: ["Support files/Info.plist"]
        ),
        
        // Realm Database
        
        .target(
            name: "PimineDatabase",
            dependencies: [
                .product(name: "RealmSwift", package: "Realm")
            ],
            path: "PimineDatabase",
            exclude: ["Support files/Info.plist"]
        ),
        
        // Concurrency
        
        .target(
            name: "PimineConcurrency",
            path: "PimineConcurrency",
            exclude: ["Support files/Info.plist"]
        ),
    ]
)
