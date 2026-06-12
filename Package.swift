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
        .package(url: "https://github.com/LottieFiles/dotlottie-ios.git", exact: "0.9.2"),
    ],
    targets: [
        // MARK: - Foundation Layers (의존성 없음)
        .target(
            name: "Domain",
            dependencies: [],
            path: "Sources/Domain"
        ),
        .target(
            name: "Core",
            dependencies: [],
            path: "Sources/Core"
        ),
        .target(
            name: "KeyboardCore",
            dependencies: [],
            path: "Sources/KeyboardCore"
        ),

        // MARK: - Infrastructure Layer
        .target(
            name: "Data",
            dependencies: [
                "Domain",
                "Core",
            ],
            path: "Sources/Data"
        ),

        // MARK: - UI Foundation Layer
        .target(
            name: "Shared",
            dependencies: [
                "Core",
                .product(name: "DotLottie", package: "dotlottie-ios"),
            ],
            path: "Sources/Shared",
            resources: [
                .process("Resource/Assets.xcassets"),
            ]
        ),

        // MARK: - Feature Layers
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
            dependencies: ["Domain", "Shared", "Core"],
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
