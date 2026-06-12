// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WatchOutPackage",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Data", targets: ["Data"]),
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        .library(name: "Platform", targets: ["Platform"]),
        .library(name: "KeyboardKit", targets: ["KeyboardKit"]),
        .library(name: "Features", targets: ["Features"]),
    ],
    dependencies: [
        .package(url: "https://github.com/LottieFiles/dotlottie-ios.git", exact: "0.9.2"),
    ],
    targets: [
        // MARK: - 순수 도메인 (의존성 없음)
        .target(
            name: "Domain",
            dependencies: [],
            path: "Sources/Domain"
        ),

        // MARK: - 플랫폼 공통 (로깅, 알림, 권한, AppGroup 저장소)
        .target(
            name: "Platform",
            dependencies: [],
            path: "Sources/Platform"
        ),

        // MARK: - 데이터 (APIClient, RepositoryImpl, Keychain)
        .target(
            name: "Data",
            dependencies: [
                "Domain",
                "Platform",
            ],
            path: "Sources/Data"
        ),

        // MARK: - 디자인 시스템 (컴포넌트, 리소스, 폰트/컬러, 라우팅 타입)
        .target(
            name: "DesignSystem",
            dependencies: [
                "Platform",
                .product(name: "DotLottie", package: "dotlottie-ios"),
            ],
            path: "Sources/DesignSystem",
            resources: [
                .process("Resource/Assets.xcassets"),
            ]
        ),

        // MARK: - 키보드 익스텐션 코어 (한글 엔진, 레이아웃, 사기 탐지 세션)
        .target(
            name: "KeyboardKit",
            dependencies: ["Platform"],
            path: "Sources/KeyboardKit"
        ),

        // MARK: - 화면 (Auth/Home/Group/Main/Setting/Experience 폴더로 구분)
        // Data 의존은 Repository 기본값 주입 때문 — composition root 도입 시 제거 예정
        .target(
            name: "Features",
            dependencies: [
                "Domain",
                "Data",
                "DesignSystem",
                "Platform",
                .product(name: "DotLottie", package: "dotlottie-ios"),
            ],
            path: "Sources/Features"
        ),
    ]
)
