//
//  JoinGroupRequest.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation

// MARK: - GroupGorupRequest
public struct JoinGorupRequest: Codable {
    public let joinCode, userID, nickname: String
    
    public init(joinCode: String, userID: String, nickname: String) {
        self.joinCode = joinCode
        self.userID = userID
        self.nickname = nickname
    }
    
    public enum CodingKeys: String, CodingKey {
        case joinCode = "join_code"
        case userID = "user_id"
        case nickname = "nickname"
    }
}
