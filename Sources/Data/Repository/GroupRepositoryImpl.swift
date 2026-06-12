//
//  GroupRepositoryImpl.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation
import Domain

public final class GroupRepositoryImpl: GroupRepository {
    private let client: APIClient

    public init(client: APIClient = .default) {
        self.client = client
    }

    public func createGroup(userId: String, groupName: String, nickname: String) async throws -> GroupSummary {
        let request = CreateGroupRequest(userID: userId, groupName: groupName, nickname: nickname)
        let response: CreateGroupResponse = try await client.request(
            try Endpoint(path: "family_group/create", method: .post, json: request)
        )
        return GroupSummary(groupId: response.groupID, joinCode: response.joinCode)
    }

    public func joinGroup(code: String, userId: String, nickname: String) async throws {
        let request = JoinGroupRequest(joinCode: code, userID: userId, nickname: nickname)
        try await client.request(
            try Endpoint(path: "family_group/join", method: .post, json: request)
        )
    }

    public func leaveGroup(userId: String) async throws {
        try await client.request(
            Endpoint(path: "family_group/leave/\(userId)", method: .delete)
        )
    }

    public func fetchGroupInfo(userId: String) async throws -> FamilyGroup {
        let response: InfoGroupResponse = try await client.request(
            Endpoint(path: "family_group/info/\(userId)", method: .get)
        )
        return response.toEntity()
    }

    public func verifyJoinCode(_ code: String) async throws -> Bool {
        let response: VerifyResponse = try await client.request(
            try Endpoint(path: "family_group/verify", method: .post, json: VerifyRequest(joinCode: code))
        )
        return response.isValid
    }
}

// MARK: - DTO → Entity 매핑
extension InfoGroupResponse {
    func toEntity() -> FamilyGroup {
        FamilyGroup(
            id: groupID,
            name: groupName,
            joinCode: joinCode,
            creatorId: creatorID,
            members: members.map { $0.toEntity() },
            createdAt: createdAt
        )
    }
}

extension Member {
    func toEntity() -> GroupMember {
        GroupMember(
            id: userID,
            nickname: nickname,
            profileImage: profileImage,
            warningCount: warningCount,
            dangerCount: dangerCount,
            isCreator: isCreator,
            notificationEnabled: notificationEnabled
        )
    }
}
