//
//  FamilyGroup.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation

public struct FamilyGroup: Equatable {
    public let id: String
    public let name: String
    public let joinCode: String
    public let creatorId: String
    public let members: [GroupMember]
    public let createdAt: String

    public init(
        id: String,
        name: String,
        joinCode: String,
        creatorId: String,
        members: [GroupMember],
        createdAt: String
    ) {
        self.id = id
        self.name = name
        self.joinCode = joinCode
        self.creatorId = creatorId
        self.members = members
        self.createdAt = createdAt
    }
}

public struct GroupMember: Equatable, Identifiable {
    public let id: String
    public let nickname: String
    public let profileImage: String
    public let warningCount: Int
    public let dangerCount: Int
    public let isCreator: Bool
    public let notificationEnabled: Bool

    public init(
        id: String,
        nickname: String,
        profileImage: String,
        warningCount: Int,
        dangerCount: Int,
        isCreator: Bool,
        notificationEnabled: Bool
    ) {
        self.id = id
        self.nickname = nickname
        self.profileImage = profileImage
        self.warningCount = warningCount
        self.dangerCount = dangerCount
        self.isCreator = isCreator
        self.notificationEnabled = notificationEnabled
    }
}

public struct GroupSummary: Equatable {
    public let groupId: String
    public let joinCode: String

    public init(groupId: String, joinCode: String) {
        self.groupId = groupId
        self.joinCode = joinCode
    }
}
