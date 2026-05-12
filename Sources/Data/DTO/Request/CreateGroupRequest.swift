//
//  CreateGroupRequest.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation

// MARK: - CreateGorupRequest
public struct CreateGroupRequest: Codable {
    public let userID, groupName,nickname: String

    public init(userID: String, groupName: String, nickname: String) {
        self.userID = userID
        self.groupName = groupName
        self.nickname = nickname
    }
    
    public enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case groupName = "group_name"
        case nickname = "nickname"
    }
}
