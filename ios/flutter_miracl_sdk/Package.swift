// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "flutter_miracl_sdk",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "flutter-miracl-sdk", targets: ["flutter_miracl_sdk"])
    ],
    dependencies: [
        .package(url: "https://github.com/miracl/trust-sdk-ios", exact: "1.2.0")
    ],
    targets: [
        .target(
            name: "flutter_miracl_sdk",
            dependencies: [
                .product(name: "MIRACLTrust", package: "trust-sdk-ios")
            ],
            resources: []
        )
    ]
)