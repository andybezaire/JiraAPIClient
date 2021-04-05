// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "JiraAPIClient",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(name: "JiraAPIClient", targets: ["JiraAPIClient"])
    ],
    dependencies: [
        .package(name: "Authorization", url: "https://github.com/andybezaire/Authorization.git", from: "1.4.0"),
        .package(name: "CombineExtras", url: "https://github.com/andybezaire/CombineExtras.git", from: "1.4.0"),
        .package(name: "DefaultsWrapper", url: "https://github.com/andybezaire/DefaultsWrapper.git", from: "1.3.0"),
        .package(name: "JiraAPI", url: "https://github.com/andybezaire/JiraAPI.git", from: "0.2.1"),
        .package(name: "Mocker", url: "https://github.com/andybezaire/Mocker.git", from: "2.3.0")
    ],
    targets: [
        .target(name: "JiraAPIClient", dependencies: ["Authorization", "CombineExtras", "DefaultsWrapper", "JiraAPI"]),
        .target(name: "JiraAPIClientTestUtils", dependencies: ["JiraAPIClient"], path: "Tests/JiraAPIClientTestUtils"),
        .testTarget(name: "JiraAPIClientTests", dependencies: ["JiraAPIClient", "JiraAPIClientTestUtils", "Mocker"])
    ]
)
