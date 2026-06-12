//
//  GroupRepository.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation

public protocol GroupRepository {
    func createGroup(userId: String, groupName: String, nickname: String) async throws -> GroupSummary
    func joinGroup(code: String, userId: String, nickname: String) async throws
    func leaveGroup(userId: String) async throws
    func fetchGroupInfo(userId: String) async throws -> FamilyGroup
    func verifyJoinCode(_ code: String) async throws -> Bool
}
