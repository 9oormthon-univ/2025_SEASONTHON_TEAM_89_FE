//
//  AppState.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//


import Foundation

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool
    @Published var isOnboardingCompleted: Bool

    init() {
        // TODO: 키체인에서 토큰 유무를 확인하여 로그인 상태 초기화
        if let accessToken = TokenManager.shared.loadAccessToken() {
                    // 2. 토큰이 존재하고, 비어있지 않다면 로그인 상태로 판단합니다.
                    self.isLoggedIn = !accessToken.isEmpty
                } else {
                    // 3. 토큰이 없으면 비로그인 상태로 판단합니다.
                    self.isLoggedIn = false
                }
        // UserDefaults에서 온보딩 완료 여부 초기화
        self.isOnboardingCompleted = SharedUserDefaults.isOnboarding
    }
}

