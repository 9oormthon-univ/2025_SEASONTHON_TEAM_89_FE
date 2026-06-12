//
//  KakaoAuthGatewayImpl.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation
import Domain
import KakaoSDKUser

public final class KakaoAuthGatewayImpl: KakaoAuthGateway {

    public init() {}

    @MainActor
    public func authorize() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    Self.resume(continuation, token: oauthToken?.accessToken, error: error)
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    Self.resume(continuation, token: oauthToken?.accessToken, error: error)
                }
            }
        }
    }

    private static func resume(
        _ continuation: CheckedContinuation<String, Error>,
        token: String?,
        error: Error?
    ) {
        if let error {
            continuation.resume(throwing: error)
        } else if let token {
            continuation.resume(returning: token)
        } else {
            continuation.resume(throwing: APIError.unknown(statusCode: -1, message: "카카오 토큰을 받지 못했습니다"))
        }
    }
}
