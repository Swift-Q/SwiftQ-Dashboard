// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftQ-Dashboard",
    dependencies: [
        // 💧 A server-side Swift web framework. 
        .package(url: "https://github.com/vapor/vapor.git", .branch("beta")),
        .package(url: "https://github.com/vapor/leaf.git", .branch("beta")),
        .package(url: "https://github.com/vapor/redis.git", .branch("beta")),
        
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "Redis", "Leaf"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)

