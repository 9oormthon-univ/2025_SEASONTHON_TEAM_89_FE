//
//  LoginViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation
import Combine
import Domain
import Platform

final class LoginViewModel: ObservableObject {

    @Published var isLoading: Bool = false

    private let repository: AuthRepository
    private let userManager: UserManager
    private let tokenStore: TokenStore
    private let kakaoAuthGateway: KakaoAuthGateway

    init(
        repository: AuthRepository,
        userManager: UserManager,
        tokenStore: TokenStore,
        kakaoAuthGateway: KakaoAuthGateway
    ) {
        self.repository = repository
        self.userManager = userManager
        self.tokenStore = tokenStore
        self.kakaoAuthGateway = kakaoAuthGateway
    }

    // MARK: - 로그인 처리 함수
    func handleKakaoLogin(completion: @escaping (_ success: Bool) -> Void) {
        isLoading = true
        Task { @MainActor in
            do {
                let kakaoToken = try await kakaoAuthGateway.authorize()
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
                Log.error("카카오 로그인 실패: \(error)")
                isLoading = false
                completion(false)
            }
        }
    }
}
