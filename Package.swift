// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "JiraAPIClient",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(name: "JiraAPIClient", targets: ["JiraAPIClient"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "JiraAPIClient", dependencies: []),
        .testTarget(name: "JiraAPIClientTests", dependencies: ["JiraAPIClient"]),
    ]
)
