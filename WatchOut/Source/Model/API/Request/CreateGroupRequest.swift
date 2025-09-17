//
//  CreateGroupRequest.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation

// MARK: - CreateGorupRequest
struct CreateGroupRequest: Codable {
    let groupName, userID, userName: String

    enum CodingKeys: String, CodingKey {
        case groupName = "group_name"
        case userID = "user_id"
        case userName = "user_name"
    }
}
