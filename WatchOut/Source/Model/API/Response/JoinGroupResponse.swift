//
//  JoinGroupResponse.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation

// MARK: - GroupGorupResponse
struct JoinGorupResponse: Codable {
    let groupID, creatorName, joinedAt: String

    enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case creatorName = "creator_name"
        case joinedAt = "joined_at"
    }
}
