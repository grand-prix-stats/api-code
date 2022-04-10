// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "grand-prix-stats-api",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "generator", targets: ["APIGenerator"]),
        .executable(name: "gps", targets: ["GrandPrixStatsCLI"]),
        .library(name: "GrandPrixStatsKit", targets: ["GrandPrixStatsKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/eneko/Swiftgger.git", branch: "master"),
        .package(url: "https://github.com/SwiftOnTheServer/SwiftDotEnv.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/vapor/mysql-kit.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(name: "GPSModels", dependencies: []),
        .executableTarget(name: "APIGenerator", dependencies: [
            .product(name: "MySQLKit", package: "mysql-kit"),
            "SwiftDotEnv", "GPSModels", "Swiftgger"
        ]),
        .executableTarget(name: "GrandPrixStatsCLI", dependencies: ["GrandPrixStatsKit"]),
        .target(name: "GrandPrixStatsKit", dependencies: ["GPSModels"])
    ]
)
