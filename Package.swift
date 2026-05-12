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
        .library(name: "FeatureGroup", targets: ["FeatureGroup"]),
        .library(name: "FeatureExperience", targets: ["FeatureExperience"]),
        .library(name: "FeatureSetting", targets: ["FeatureSetting"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/LottieFiles/dotlottie-ios.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Shared",
            dependencies: [
                .product(name: "DotLottie", package: "dotlottie-ios"),
            ],
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
            dependencies: [
                "Domain",
                "Data",
                "Shared",
                "Core",
                .product(name: "DotLottie", package: "dotlottie-ios"),
            ],
            path: "Sources/FeatureAuth"
        ),
        .target(
            name: "FeatureHome",
            dependencies: ["Domain", "Data", "Shared", "Core"],
            path: "Sources/FeatureHome"
        ),
        .target(
            name: "FeatureGroup",
            dependencies: ["Domain", "Data", "Shared", "Core"],
            path: "Sources/FeatureGroup"
        ),
        .target(
            name: "FeatureExperience",
            dependencies: ["Domain", "Data", "Shared", "Core", "KeyboardCore"],
            path: "Sources/FeatureExperience"
        ),
        .target(
            name: "FeatureSetting",
            dependencies: ["Domain", "Data", "Shared", "Core"],
            path: "Sources/FeatureSetting"
        ),
        .target(
            name: "FeatureMain",
            dependencies: [
                "Domain",
                "Data",
                "Shared",
                "Core",
                "FeatureHome",
                "FeatureSetting",
                .product(name: "DotLottie", package: "dotlottie-ios"),
            ],
            path: "Sources/FeatureMain"
        ),
    ]
)
