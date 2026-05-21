//
//  InfoGroupResponse.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation

// MARK: - InfoGroupResponse
public struct InfoGroupResponse: Codable {
    public let groupID, groupName, joinCode, creatorID: String
    public let memberCount: Int
    public var members: [Member]
    public let createdAt: String

    public enum CodingKeys: String, CodingKey {
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
public struct Member: Codable {
    public let userID, nickname: String
    public let profileImage: String
    public let warningCount, dangerCount: Int
    
    public let isCreator: Bool
    public let joinedAt: String
    public let notificationEnabled: Bool
    
    public init(userID: String, nickname: String, profileImage: String, warningCount: Int, dangerCount: Int, isCreator: Bool, joinedAt: String, notificationEnabled: Bool) {
        self.userID = userID
        self.nickname = nickname
        self.profileImage = profileImage
        self.warningCount = warningCount
        self.dangerCount = dangerCount
        self.isCreator = isCreator
        self.joinedAt = joinedAt
        self.notificationEnabled = notificationEnabled
    }
    public enum CodingKeys: String, CodingKey {
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
