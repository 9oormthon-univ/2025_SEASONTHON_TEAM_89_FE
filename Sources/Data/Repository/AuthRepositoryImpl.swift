//
//  AuthRepositoryImpl.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation
import Domain

public final class AuthRepositoryImpl: AuthRepository {
    private let client: APIClient

    public init(client: APIClient = .default) {
        self.client = client
    }

    public func loginWithKakao(accessToken: String, deviceToken: String?) async throws -> LoginResult {
        let request = KakaoLoginRequest(
            accessToken: accessToken,
            deviceToken: deviceToken ?? "시뮬레이터"
        )
        let response: LoginResponse = try await client.request(
            try Endpoint(path: "auth/kakao/token", method: .post, json: request)
        )
        return LoginResult(
            accessToken: response.accessToken,
            user: response.user,
            isNewUser: response.isNewUser
        )
    }

    public func deleteAccount(userId: String) async throws {
        try await client.request(
            try Endpoint(path: "auth/kakao/delete", method: .delete, json: KakaoDeleteRequest(userId: userId))
        )
    }
}
