//
//  LoginViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//
// ViewModels/LoginViewModel.swift

import Foundation
import Combine
import KakaoSDKUser

final class LoginViewModel: ObservableObject {

    
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading: Bool = false
    // MARK: - 로그인 처리 함수
    
    func handleKakaoLogin(completion: @escaping (_ success: Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoTalk(completion: completion)
        } else {
            loginWithKakaoAccount(completion: completion)
        }
    }

    private func loginWithKakaoTalk(completion: @escaping (_ success: Bool) -> Void) {
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
            if let error = error {
                print("카카오톡 로그인 실패: \(error)")
                completion(false)
                return
            }
            if let accessToken = oauthToken?.accessToken {
                self?.requestLoginToServer(with: accessToken, completion: completion)
            }
        }
    }

    private func loginWithKakaoAccount(completion: @escaping (_ success: Bool) -> Void) {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            if let error = error {
                print("카카오 계정 로그인 실패: \(error)")
                completion(false)
                return
            }
            if let accessToken = oauthToken?.accessToken {
                self?.requestLoginToServer(with: accessToken, completion: completion)
            }
        }
    }
    
    private func requestLoginToServer(with kakaoToken: String, completion: @escaping (_ success: Bool) -> Void) {
        isLoading = true
        authService.kakaoLogin(token: kakaoToken)
            .sink { [weak self]
                result in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .finished:
                    break // 성공 케이스는 receiveValue에서 처리
                case .failure(let error):
                    print("서버 로그인 실패: \(error.localizedDescription)")
                    completion(false) // 서버 통신 실패 시 false 반환
                }
            } receiveValue: { loginResponse in
                // 서버로부터 받은 토큰을 키체인에 저장
                UserManager.shared.setCurrentUser(loginResponse.user)
                TokenManager.shared.saveAccessToken(loginResponse.accessToken)
                print("서버 로그인 성공! 사용자: \(loginResponse.user.nickname)")

                // ✅ 모든 과정이 성공했으므로 true를 반환
                completion(true)
            }
            .store(in: &cancellables)
    }
}
