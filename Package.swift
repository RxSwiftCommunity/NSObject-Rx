// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "NSObject+Rx",
    platforms: [
        .iOS(.v8), .macOS(.v10_10), .tvOS(.v9), .watchOS(.v3)
    ],
    products: [
        .library(name: "NSObject+Rx", targets: [ "NSObject+Rx" ])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0" )
    ],
    targets: [
        .target(name: "NSObject+Rx", dependencies: [ "RxSwift", "RxCocoa" ], path: "Sources"),
    ]
)
