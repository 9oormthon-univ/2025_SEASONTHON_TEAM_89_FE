# 위허메, 금융범죄를 예방하는 가장 똑똑한 키보드
<img width="1347" height="298" alt="Slice 1 (3)" src="https://github.com/user-attachments/assets/e7c967dc-a039-4173-8627-7f4d573041fe" />

<p align="center">
<img height="387" alt="Group 1597880445" src="https://github.com/user-attachments/assets/6dc9d80b-a9ba-474a-8ffc-d3c030386382" />
</p>

위급한 판단 실수의 순간!  
허위 정보에 흔들리지 않도록!  
메시지를 감지해! 금융범죄를 예방하는 키보드 기반 서비스

## 시스템 아키텍처
<img width="1122" height="313" alt="Slice 2" src="https://github.com/user-attachments/assets/677c64c8-bae1-4200-ad51-6cd78d5216a5" />

## 프로젝트 구조
```
2025_SEASONTHON_TEAM_89_FE/
├── README.md
├── .gitignore
├── WatchOut/                          # 메인 앱 모듈
│   ├── App/                          # 앱 진입점 및 설정
│   │   ├── AppDelegate.swift         # 앱 델리게이트
│   │   └── WatchOutApp.swift         # 메인 앱 진입점
│   ├── Assets.xcassets/              # 앱 리소스 (이미지, 색상)
│   │   ├── AppIcon.appiconset/       # 앱 아이콘
│   │   ├── MainColor.colorset/       # 메인 컬러
│   │   ├── gray100~500.colorset/     # 그레이 컬러 팔레트
│   │   └── [기타 이미지 및 아이콘들]
│   ├── Component/                    # 재사용 가능한 UI 컴포넌트
│   │   ├── CustomNavigationBar.swift # 커스텀 네비게이션 바
│   │   └── CustomTextField.swift     # 커스텀 텍스트 필드
│   ├── Core/                         # 핵심 기능 및 유틸리티
│   │   ├── Extension/                # Swift Extension들
│   │   └── Service/                  # 공통 서비스
│   ├── Feature/                      # 주요 기능별 모듈
│   │   ├── Experience/               # 사용자 경험 관련
│   │   ├── Group/                    # 그룹 기능
│   │   ├── Home/                     # 홈 화면
│   │   ├── Main/                     # 메인 기능
│   │   ├── Onboarding/               # 온보딩 화면
│   │   ├── Report/                   # 신고 및 리포트 기능
│   │   └── Setting/                  # 설정 화면
│   ├── Font/                         # 폰트 리소스
│   │   ├── GangwonEduPower/          # 강원교육파워체
│   │   └── Pretendard/               # Pretendard 폰트
│   ├── Model/                        # 데이터 모델
│   │   ├── Status.swift              # 상태 모델
│   │   ├── Main/                     # 메인 관련 모델
│   │   └── Path/                     # 경로 관련 모델
│   ├── ContentView.swift             # 메인 콘텐츠 뷰
│   ├── Info.plist                    # 앱 정보 설정
│   └── WatchOut.entitlements         # 앱 권한 설정
└── WatchOutkeyboard/                 # 키보드 확장 모듈
    ├── Engine/                       # 키보드 엔진
    │   ├── Hangul.swift              # 한글 처리
    │   └── HangulEngine.swift        # 한글 입력 엔진
    ├── Model/                        # 키보드 관련 모델
    │   ├── ChatRequest.swift         # 채팅 요청 모델
    │   ├── ChatResponse.swift        # 채팅 응답 모델
    │   ├── KeyType.swift             # 키 타입 정의
    │   └── RiskLevel.swift           # 위험도 레벨
    ├── Service/                      # 키보드 서비스
    │   ├── ChatService.swift         # 채팅 서비스
    │   └── Haptic.swift              # 햅틱 피드백
    ├── View/                         # 키보드 UI
    │   ├── KeyboardView.swift        # 키보드 뷰
    │   └── KeyboardViewModel.swift   # 키보드 뷰모델
    ├── KeyboardViewController.swift  # 키보드 메인 컨트롤러
    ├── TypingDebounceManager.swift   # 타이핑 디바운스 관리
    ├── Info.plist                    # 키보드 확장 정보
    └── WatchOutkeyboard.entitlements # 키보드 확장 권한
```

## 주요 기능

### 메인 앱 (WatchOut)
- **온보딩**: 사용자 첫 사용 시 가이드 제공
- **홈**: 메인 대시보드 및 현황 확인
- **그룹**: 사용자 그룹 관리 기능
- **리포트**: 사용 통계 및 분석 정보
- **설정**: 앱 설정 및 개인화 옵션

### 키보드 확장 (WatchOutkeyboard)
- **실시간 텍스트 분석**: 입력되는 텍스트의 위험도 실시간 평가
- **한글/영문 지원**: 다국어 키보드 입력 지원
- **위험도 알림**: 부적절한 언어 사용 시 경고 제공
- **햅틱 피드백**: 촉각적 피드백을 통한 사용자 알림

## 개발 환경 설정

### 요구 사항
- Xcode 15.0 이상
- iOS 15.0 이상
- Swift 5.9 이상

### 설치 및 실행
1. 프로젝트 클론
```bash
git clone https://github.com/9oormthon-univ/2025_SEASONTHON_TEAM_89_FE.git
cd 2025_SEASONTHON_TEAM_89_FE
```

2. Xcode에서 프로젝트 열기
```bash
open WatchOut.xcodeproj
```

3. 타겟 설정
   - **WatchOut**: 메인 앱
   - **WatchOutkeyboard**: 키보드 확장

4. 빌드 및 실행
   - 시뮬레이터 또는 실제 기기에서 테스트 가능
   - 키보드 확장 기능 테스트를 위해서는 실제 기기 권장

## 아키텍처

### MVVM 패턴
- **Model**: 데이터 및 비즈니스 로직
- **View**: UI 표현 계층 (SwiftUI)
- **ViewModel**: View와 Model 간의 바인딩 및 로직 처리

### 모듈화 구조
- **Feature 기반 분리**: 각 기능별로 독립적인 모듈 구성
- **Component 재사용**: 공통 UI 컴포넌트의 모듈화
- **Service 레이어**: 네트워크, 데이터 처리 등의 서비스 분리
