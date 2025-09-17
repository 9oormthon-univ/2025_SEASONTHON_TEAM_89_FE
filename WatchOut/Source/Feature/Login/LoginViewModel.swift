//
//  LoginViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation
import Combine
import KakaoSDKUser

final class LoginViewModel: ObservableObject {
    @Published var isLoggedIn = false
    
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()

    // 카카오 로그인 전체 플로우를 처리하는 메인 함수
    func handleKakaoLogin() {
        // 1. 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoTalk()
        } else {
            loginWithKakaoAccount()
        }
    }

    // 카카오톡 앱으로 로그인
    private func loginWithKakaoTalk() {
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
            if let error = error {
                print("카카오톡 로그인 실패: \(error)")
                return
            }
            if let accessToken = oauthToken?.accessToken {
                // 2. 카카오 로그인 성공 후, 발급받은 토큰으로 우리 서버에 로그인 요청
                self?.requestLoginToServer(with: accessToken)
            }
        }
    }

    // 카카오 계정(웹뷰)으로 로그인
    private func loginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            if let error = error {
                print("카카오 계정 로그인 실패: \(error)")
                return
            }
            if let accessToken = oauthToken?.accessToken {
                self?.requestLoginToServer(with: accessToken)
            }
        }
    }
    
    private func requestLoginToServer(with kakaoToken: String) {
        authService.kakaoLogin(token: kakaoToken)
            .sink { completion in
                // ... (에러 처리 부분은 동일)
            } receiveValue: { [weak self] loginResponse in
                // ⬇️ 응답 파라미터 이름을 loginResponse로 변경하고, 그 안의 데이터를 사용합니다.
                
                // 1. 응답에 refreshToken이 없으므로 accessToken만 저장하도록 수정합니다.
                TokenManager.shared.saveAccessToken(loginResponse.accessToken)
                
                // 2. 새로 받은 사용자 정보와 신규 유저 여부를 활용할 수 있습니다.
                print("로그인 성공!")
                print("사용자 닉네임: \(loginResponse.user.nickname)")
                print("프로필 이미지 URL: \(loginResponse.user.profileImage)")
                print("신규 유저인가요? \(loginResponse.isNewUser)")

                // 3. 로그인 상태 업데이트 (UI 변경)
                DispatchQueue.main.async {
                    self?.isLoggedIn = true
                }
            }
            .store(in: &cancellables)
    }
}
