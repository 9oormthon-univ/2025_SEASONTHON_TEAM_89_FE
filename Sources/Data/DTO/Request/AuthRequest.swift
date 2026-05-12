//
//  AuthRequest.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation

public struct KakaoLoginRequest: Codable {
    public let accessToken: String, DeviceType: String
    
    public enum CodingKeys: String, CodingKey {
        case accessToken =  "access_token"
        case DeviceType = "device_token"
    }
}

public struct KakaoDeleteRequest: Codable {
    public let userId: String
    
    public enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
