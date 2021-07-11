// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftYogaKit",
    platforms: [
        .macOS(.v10_10), .iOS(.v9), .tvOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftYogaKit",
            targets: ["SwiftYogaKit"]),
        .library(
            name: "Yoga",
            targets: ["Yoga"])
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftYogaKit",
            dependencies: ["Yoga"],
            path: ".",
            sources: ["Sources/SwiftYogaKit"]),
        .target(
            name: "Yoga",
            path: ".",
            sources: ["Sources/yoga/yoga"],
            publicHeadersPath: "Sources/yoga/yoga/include",
            cSettings: [
                .headerSearchPath("Sources/yoga")
            ]),
        .testTarget(
            name: "Tests",
            dependencies: ["SwiftYogaKit"],
            path: ".",
            sources: ["Tests"])
    ],
    swiftLanguageVersions: [.v5],
    cLanguageStandard: .gnu11,
    cxxLanguageStandard: .gnucxx14
)
