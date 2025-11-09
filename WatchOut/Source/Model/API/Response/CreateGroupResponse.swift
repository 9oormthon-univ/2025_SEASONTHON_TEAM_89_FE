//
//  CreateResponse.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation

// MARK: - CreateGorupResponse
struct CreateGroupResponse: Codable {
    let groupID, joinCode, creatorID: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case joinCode = "join_code"
        case creatorID = "creator_id"
        case createdAt = "created_at"

    }
}
