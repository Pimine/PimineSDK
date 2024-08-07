// swift-tools-version:5.8
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
        ),
        
        .library(
            name: "PimineFirebase",
            targets: ["PimineFirebase"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Pimine/SVProgressHUD", branch: "master"),
        .package(url: "https://github.com/bizz84/SwiftyStoreKit.git", .upToNextMajor(from: "0.16.0")),
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/realm/realm-cocoa", .upToNextMajor(from: "10.0.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.0.0"))
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
            dependencies: ["PimineUtilities"],
            path: "PimineHandyExtensions",
            exclude: ["Support files/Info.plist"]
        ),
        
        // RevenueCatStore
        
        .target(
            name: "PimineRevenueCatStore",
            dependencies: [
                "PimineUtilities",
                "SVProgressHUD",
                .product(name: "RevenueCat", package: "purchases-ios")
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
                .product(name: "RealmSwift", package: "realm-cocoa")
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
        
        // Firebase
        
        .target(
            name: "PimineFirebase",
            dependencies: [
                "PimineUtilities",
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ],
            path: "PimineFirebase",
            exclude: ["Support files/Info.plist"]
        ),
        
    ]
)
