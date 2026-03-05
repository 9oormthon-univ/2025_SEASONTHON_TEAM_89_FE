//
//  JoinGroupRequest.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation

// MARK: - GroupGorupRequest
struct JoinGorupRequest: Codable {
    let joinCode, userID, nickname: String

    enum CodingKeys: String, CodingKey {
        case joinCode = "join_code"
        case userID = "user_id"
        case nickname = "nickname"
    }
}
