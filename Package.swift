// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "grand-prix-stats-api",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "generator", targets: ["APIGenerator"]),
        .executable(name: "gps-api-client", targets: ["APIClient"]),
        .library(name: "GrandPrixStatsKit", targets: ["GrandPrixStatsKit"])
    ],
    dependencies: [
        .package(name: "GrandPrixStats", path: "../GrandPrixStats"),
        .package(url: "https://github.com/eneko/Swiftgger.git", branch: "master"),
        .package(url: "https://github.com/eneko/SwiftDotEnv", branch: "main"),
        .package(url: "https://github.com/vapor/mysql-kit.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .executableTarget(name: "APIGenerator", dependencies: [
            .product(name: "MySQLKit", package: "mysql-kit"),
            .product(name: "GPSModels", package: "GrandPrixStats"),
            "SwiftDotEnv", "Swiftgger"
        ]),
        .executableTarget(name: "APIClient", dependencies: ["GrandPrixStatsKit"]),
        .target(name: "GrandPrixStatsKit", dependencies: [
            .product(name: "GPSModels", package: "GrandPrixStats"),
        ])
    ]
)
