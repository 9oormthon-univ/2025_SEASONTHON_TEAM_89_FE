//
//  CreateGroupRequest.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation

// MARK: - CreateGorupRequest
struct CreateGroupRequest: Codable {
    let userID, nickname: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickname = "nickname"
    }
}
