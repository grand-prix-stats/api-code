// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "grand-prix-stats-api",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "generator", targets: ["APIGenerator"]),
        .executable(name: "gps", targets: ["GrandPrixStatsCLI"]),
        .library(name: "GrandPrixStatsKit", targets: ["GrandPrixStatsKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/eneko/Swiftgger.git", .branch("master")),
        .package(url: "https://github.com/SwiftOnTheServer/SwiftDotEnv.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/vapor/mysql.git", .upToNextMajor(from: "3.1.0"))
    ],
    targets: [
        .target(name: "GPSModels", dependencies: []),
        .target(name: "APIGenerator", dependencies: ["SwiftDotEnv", "MySQL", "GPSModels", "Swiftgger"]),
        .target(name: "GrandPrixStatsCLI", dependencies: ["GrandPrixStatsKit"]),
        .target(name: "GrandPrixStatsKit", dependencies: ["GPSModels"])
    ]
)
