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
                    self.isLoggedIn = !accessToken.isEmpty
                } else {   
                    self.isLoggedIn = false
                }
        self.isOnboardingCompleted = SharedUserDefaults.isOnboarding
    }
}

