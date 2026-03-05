//
//  AuthRequest.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation

struct KakaoLoginRequest: Codable {
    let accessToken: String, DeviceType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken =  "access_token"
        case DeviceType = "device_token"
    }
}

struct KakaoDeleteRequest: Codable {
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
