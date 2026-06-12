//
//  TokenManager.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation
import Platform

public final class TokenManager {
    public static let shared = TokenManager()

    private let keychain = KeychainStorage()

    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let deviceTokenKey = "deviceToken"

    private init() {}

    public func saveDeviceToken(_ token: String) {
        keychain.set(token, forKey: deviceTokenKey)
        Log.debug("DeviceToken 저장 완료")
    }

    public func saveAccessToken(_ token: String) {
        keychain.set(token, forKey: accessTokenKey)
        Log.debug("AccessToken 저장 완료")
    }

    public func saveRefreshToken(_ token: String) {
        keychain.set(token, forKey: refreshTokenKey)
        Log.debug("RefreshToken 저장 완료")
    }

    public func loadAccessToken() -> String? {
        keychain.string(forKey: accessTokenKey)
    }

    public func loadRefreshToken() -> String? {
        keychain.string(forKey: refreshTokenKey)
    }

    public func loadDeviceToken() -> String? {
        keychain.string(forKey: deviceTokenKey)
    }

    public func clearAllTokens() {
        keychain.remove(forKey: accessTokenKey)
        keychain.remove(forKey: refreshTokenKey)
        Log.debug("모든 토큰 삭제 완료")
    }
}
