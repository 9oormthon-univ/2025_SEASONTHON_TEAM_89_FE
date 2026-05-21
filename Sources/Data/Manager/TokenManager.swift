//
//  TokenManager.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//


import Foundation
import SwiftKeychainWrapper

public final class TokenManager {
    public static let shared = TokenManager()
    private init() {}

    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let deviceTokenKey = "deviceToken"

    public func saveDeviceToken(_ token: String) {
        KeychainWrapper.standard.set(token, forKey: deviceTokenKey)
        print("DeviceToken 저장 완료: \(token)")
    }
    
    public func saveAccessToken(_ token: String) {
        KeychainWrapper.standard.set(token, forKey: accessTokenKey)
        print("AccessToken 저장 완료: \(token)")
    }

    public func saveRefreshToken(_ token: String) {
        KeychainWrapper.standard.set(token, forKey: refreshTokenKey)
        print("RefreshToken 저장 완료: \(token)")
    }

    public func loadAccessToken() -> String? {
         return KeychainWrapper.standard.string(forKey: accessTokenKey)
        
    }

    public func loadRefreshToken() -> String? {
         return KeychainWrapper.standard.string(forKey: refreshTokenKey)
        
    }
    
    public func loadDeviceToken() -> String? {
        return KeychainWrapper.standard.string(forKey: deviceTokenKey)
    }
    
    public func clearAllTokens() {
        KeychainWrapper.standard.removeObject(forKey: accessTokenKey)
        KeychainWrapper.standard.removeObject(forKey: refreshTokenKey)
        print("모든 토큰 삭제 완료")
    }
}
