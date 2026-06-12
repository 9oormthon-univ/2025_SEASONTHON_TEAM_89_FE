//
//  LoginViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation
import Combine
import KakaoSDKUser
import Domain
import Platform

final class LoginViewModel: ObservableObject {

    @Published var isLoading: Bool = false

    private let repository: AuthRepository
    private let userManager: UserManager
    private let tokenStore: TokenStore

    init(
        repository: AuthRepository,
        userManager: UserManager,
        tokenStore: TokenStore
    ) {
        self.repository = repository
        self.userManager = userManager
        self.tokenStore = tokenStore
    }

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
                Log.error("카카오톡 로그인 실패: \(error)")
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
                Log.error("카카오 계정 로그인 실패: \(error)")
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
        Task { @MainActor in
            do {
                let result = try await repository.loginWithKakao(
                    accessToken: kakaoToken,
                    deviceToken: tokenStore.loadDeviceToken()
                )
                userManager.setCurrentUser(result.user)
                tokenStore.saveAccessToken(result.accessToken)
                Log.debug("서버 로그인 성공! 사용자: \(result.user.nickname)")
                isLoading = false
                completion(true)
            } catch {
                Log.error("서버 로그인 실패: \(error)")
                isLoading = false
                completion(false)
            }
        }
    }
}
