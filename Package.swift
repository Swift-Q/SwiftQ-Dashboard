// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "SwiftQ-Dashboard",
    dependencies: [
        // 💧 A server-side Swift web framework. 
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/redis.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/John-Connolly/terse.git", .branch("master")),
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "Redis","Leaf", "Terse"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)

