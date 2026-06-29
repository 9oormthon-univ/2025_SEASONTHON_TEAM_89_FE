//
//  AuthRequest.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation

public struct KakaoLoginRequest: Codable {
    public let accessToken: String, deviceToken: String
    
    public enum CodingKeys: String, CodingKey {
        case accessToken =  "access_token"
        case deviceToken = "device_token"
    }
}

public struct KakaoDeleteRequest: Codable {
    public let userId: String

    public enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

/// POST /auth/device-token — 디바이스 토큰 등록/갱신 (user_id 기반)
public struct DeviceTokenRequest: Codable {
    public let userId: String
    public let deviceToken: String

    public init(userId: String, deviceToken: String) {
        self.userId = userId
        self.deviceToken = deviceToken
    }

    public enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case deviceToken = "device_token"
    }
}
