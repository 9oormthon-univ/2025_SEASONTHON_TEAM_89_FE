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
WatchOut/
├── App/
│   ├── AppDelegate.swift
│   └── WatchOutApp.swift
│
├── Source/
│   ├── Feature/                    # 화면 및 기능
│   │   ├── Login/                 # 로그인
│   │   ├── Onboarding/            # 온보딩
│   │   ├── Main/                  # 메인 탭
│   │   ├── Home/                  # 홈
│   │   ├── Group/                 # 그룹 생성/참여/관리
│   │   ├── Report/                # 리포트
│   │   ├── Setting/               # 설정
│   │   ├── Experience/            # 체험하기
│   │   └── Wating/                # 대기
│   │
│   ├── Component/                  # 공통 컴포넌트
│   │   ├── CustomNavigaitonBar.swift
│   │   └── CustomTextField.swift
│   │
│   ├── Core/
│   │   ├── Extension/             # Swift Extension
│   │   └── Service/               # 서비스 레이어
│   │       ├── Auth/              # 인증 관련
│   │       ├── Group/             # 그룹 관련
│   │       ├── Common/            # 공통 서비스
│   │       └── Log/               # 로깅
│   │
│   └── Model/                      # 데이터 모델
│       ├── API/
│       │   ├── Request/           # API 요청
│       │   └── Response/          # API 응답
│       ├── User/
│       ├── Main/
│       └── Path/
│
├── Resource/
│   ├── Assets.xcassets/           # 이미지 및 컬러 에셋
│   ├── Font/                      # 폰트 파일
│   └── Animation/                 # Lottie 애니메이션
│
└── WatchOutkeyboard/               # 키보드 익스텐션
    ├── Engine/                     # 한글 입력 엔진
    ├── Service/                    # 웹소켓 및 햅틱
    ├── Model/                      # 키보드 모델
    └── View/                       # 키보드 UI

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
