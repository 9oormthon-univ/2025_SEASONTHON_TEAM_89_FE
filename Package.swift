// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WatchOutPackage",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Shared", targets: ["Shared"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "KeyboardCore", targets: ["KeyboardCore"]),
        .library(name: "Data", targets: ["Data"]),
        .library(name: "FeatureAuth", targets: ["FeatureAuth"]),
        .library(name: "FeatureMain", targets: ["FeatureMain"]),
        .library(name: "FeatureHome", targets: ["FeatureHome"]),
        .library(name: "FeatureSetting", targets: ["FeatureSetting"]),
        .library(name: "FeatureReport", targets: ["FeatureReport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
    ],
    targets: [
        .target(
            name: "Shared",
            path: "Sources/Shared",
            resources: [
                .process("Resource/Assets.xcassets"),
                .process("Resource/Font"),
                .process("Resource/Animation"),
            ]
        ),
        .target(
            name: "Core",
            dependencies: ["Shared"],
            path: "Sources/Core"
        ),
        .target(
            name: "Domain",
            dependencies: ["Core"],
            path: "Sources/Domain"
        ),
        .target(
            name: "KeyboardCore",
            dependencies: ["Core"],
            path: "Sources/KeyboardCore"
        ),
        .target(
            name: "Data",
            dependencies: [
                "Domain",
                "Core",
                .product(name: "Moya", package: "Moya"),
            ],
            path: "Sources/Data"
        ),
        .target(
            name: "FeatureAuth",
            dependencies: ["Domain", "Data", "Shared", "Core"],
            path: "Sources/FeatureAuth"
        ),
        .target(
            name: "FeatureMain",
            dependencies: ["Domain", "Data", "Shared", "Core"],
            path: "Sources/FeatureMain"
        ),
        .target(
            name: "FeatureHome",
            dependencies: ["Domain", "Data", "Shared", "Core", "KeyboardCore"],
            path: "Sources/FeatureHome"
        ),
        .target(
            name: "FeatureSetting",
            dependencies: ["Domain", "Data", "Shared", "Core"],
            path: "Sources/FeatureSetting"
        ),
        .target(
            name: "FeatureReport",
            dependencies: ["Domain", "Shared", "Core"],
            path: "Sources/FeatureReport"
        ),
    ]
)
