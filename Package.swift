// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "JiraAPIClient",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(name: "JiraAPIClient", targets: ["JiraAPIClient"]),
    ],
    dependencies: [
        .package(name: "Authorization", url: "https://github.com/andybezaire/Authorization.git", from: "1.1.0"),
        .package(name: "DefaultsWrapper", url: "https://github.com/andybezaire/DefaultsWrapper.git", from: "1.3.0"),
        .package(name: "JiraAPI", url: "https://github.com/andybezaire/JiraAPI.git", from: "0.1.2"),
    ],
    targets: [
        .target(name: "JiraAPIClient", dependencies: ["Authorization", "DefaultsWrapper", "JiraAPI"]),
        .target(name: "JiraAPIClientTestUtils", dependencies: ["JiraAPIClient"], path: "Tests/JiraAPIClientTestUtils"),
        .testTarget(name: "JiraAPIClientTests", dependencies: ["JiraAPIClient", "JiraAPIClientTestUtils"]),
    ]
)
