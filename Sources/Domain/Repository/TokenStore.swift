//
//  TokenStore.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation

public protocol TokenStore {
    func saveDeviceToken(_ token: String)
    func saveAccessToken(_ token: String)
    func saveRefreshToken(_ token: String)
    func loadAccessToken() -> String?
    func loadRefreshToken() -> String?
    func loadDeviceToken() -> String?
    func clearAllTokens()
}
