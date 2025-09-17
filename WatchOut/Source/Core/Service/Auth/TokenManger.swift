//
//  TokenManger.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//


import Foundation
// import SwiftKeychainWrapper // 라이브러리 사용 시

final class TokenManager {
    static let shared = TokenManager()
    private init() {}

    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"

    func saveAccessToken(_ token: String) {
        // Keychain.standard.set(token, forKey: accessTokenKey)
        print("AccessToken 저장 완료: \(token)")
    }

    func saveRefreshToken(_ token: String) {
        // Keychain.standard.set(token, forKey: refreshTokenKey)
        print("RefreshToken 저장 완료: \(token)")
    }

    func loadAccessToken() -> String? {
        // return Keychain.standard.string(forKey: accessTokenKey)
        return nil // 임시
    }

    func loadRefreshToken() -> String? {
        // return Keychain.standard.string(forKey: refreshTokenKey)
        return nil // 임시
    }
    
    func clearAllTokens() {
        // Keychain.standard.removeObject(forKey: accessTokenKey)
        // Keychain.standard.removeObject(forKey: refreshTokenKey)
        print("모든 토큰 삭제 완료")
    }
}
