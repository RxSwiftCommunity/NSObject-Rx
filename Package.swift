// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "NSObjectRx",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "NSObjectRx", targets: ["NSObjectRx"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "5.0.1"),
    ],
    targets: [
        .target(
            name: "NSObjectRx",
            dependencies: ["RxSwift"],
            path: ".",
            sources: ["NSObject+Rx.swift"]
        ),
    ]
)
