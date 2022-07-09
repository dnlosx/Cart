// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Cart",
    
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    
    ],
    
    products: [
        .library(name: "Cart",
                 targets: ["Cart"])
    ],
    targets: [
        .target(name: "Cart"),
        .testTarget(name: "CartTests",
                    dependencies: ["Cart"])
    ]
)
