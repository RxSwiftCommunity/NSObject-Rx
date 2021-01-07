// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "NSObject-Rx",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "NSObject-Rx", targets: ["NSObject-Rx"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "NSObject-Rx",
            dependencies: ["RxSwift"],
            path: ".",
            sources: ["NSObject+Rx.swift", "HasDisposeBag.swift"]
        ),
    ]
)
