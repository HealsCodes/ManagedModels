// swift-tools-version: 6.0
import CompilerPluginSupport
import PackageDescription

#if swift(>=5.10)
    let settings = [SwiftSetting.enableExperimentalFeature("StrictConcurrency")]
#else
    let settings = [SwiftSetting]()
#endif

let package = Package(
    name: "ManagedModels",

    platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10)],
    products: [
        .library(name: "ManagedModels", targets: ["ManagedModels"])
    ],
    dependencies: [
        // TODO: switch to the official repo once 600.0.1 is merged
        //.package(url: "https://github.com/sjavora/swift-syntax-xcframeworks.git", from: "510.0.0")
        .package(
            url: "https://github.com/openium/swift-syntax-xcframeworks.git",
            branch: "feat/swift-6-public-import-and-release")
    ],
    targets: [
        .target(
            name: "ManagedModels",
            dependencies: ["ManagedModelMacros"],
            swiftSettings: settings
        ),

        .macro(
            name: "ManagedModelMacros",
            dependencies: [
                .product(name: "SwiftSyntaxWrapper", package: "swift-syntax-xcframeworks")
            ]
        ),

        .testTarget(
            name: "ManagedModelTests",
            dependencies: ["ManagedModels"]
        ),

        .testTarget(
            name: "ManagedModelMacrosTests",
            dependencies: [
                "ManagedModelMacros",
                .product(name: "SwiftSyntaxWrapper", package: "swift-syntax-xcframeworks"),
            ]
        ),
    ],
    swiftLanguageModes: [.version("6")]
)
