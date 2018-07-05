// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "grand-prix-stats-api",
    products: [
        .executable(name: "generator", targets: ["APIGenerator"]),
        .executable(name: "gps", targets: ["GrandPrixStatsCLI"]),
        .library(name: "GrandPrixStatsKit", targets: ["GrandPrixStatsKit"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/SwiftOnTheServer/SwiftDotEnv.git", .upToNextMinor(from: "2.0.0")),
        .package(url: "https://github.com/novi/mysql-swift.git", .upToNextMinor(from: "0.9.0"))
    ],
    targets: [
        .target(name: "GPSModels", dependencies: []),
        .target(name: "APIGenerator", dependencies: ["SwiftDotEnv", "MySQL", "GPSModels"]),
        .target(name: "GrandPrixStatsCLI", dependencies: ["GrandPrixStatsKit"]),
        .target(name: "GrandPrixStatsKit", dependencies: ["GPSModels"])
    ]
)
