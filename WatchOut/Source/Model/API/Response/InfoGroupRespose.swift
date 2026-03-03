//
//  InfoGroupRespose.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation

// MARK: - InfoGroupRespose
struct InfoGroupRespose: Codable {
    let groupID, groupName, joinCode, creatorID: String
    let memberCount: Int
    var members: [Member]
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case groupName = "group_name"
        case joinCode = "join_code"
        case creatorID = "creator_id"
        case memberCount = "member_count"
        case members
        case createdAt = "created_at"
    }
}

// MARK: - Member
struct Member: Codable {
    let userID, nickname: String
    let profileImage: String
    let warningCount, dangerCount: Int
    
    let isCreator: Bool
    let joinedAt: String
    let notificationEnabled: Bool
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickname
        case profileImage = "profile_image"
        case warningCount = "warning_count"
        case dangerCount = "danger_count"
        case isCreator = "is_creator"
        case joinedAt = "joined_at"
        case notificationEnabled = "notification_enabled"
    }
}
