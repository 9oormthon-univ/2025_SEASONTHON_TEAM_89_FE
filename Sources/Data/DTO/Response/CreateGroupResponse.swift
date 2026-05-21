//
//  CreateResponse.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation

// MARK: - CreateGroupResponse
public struct CreateGroupResponse: Codable {
    public let groupID, joinCode, creatorID: String
    public let createdAt: String

    public init(groupID: String, joinCode: String, creatorID: String, createdAt: String) {
        self.groupID = groupID
        self.joinCode = joinCode
        self.creatorID = creatorID
        self.createdAt = createdAt
    }
    
    public enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case joinCode = "join_code"
        case creatorID = "creator_id"
        case createdAt = "created_at"

    }
}
