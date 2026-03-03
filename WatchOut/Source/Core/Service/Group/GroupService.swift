//
//  GroupService.swift
//  WatchOut
//
//  Created by 어재선 on 9/16/25.
//

import Foundation
import Moya
protocol GroupServiceType {
    func createGroup(groupRequest: CreateGroupRequest, completion: @escaping (Result<CreateGroupResponse, APIError>) -> Void)
    func joinGroup(joinGroup: JoinGorupRequest, completion: @escaping (Result<Void, APIError>) -> Void)
    func leaveGroup(userID: String, completion: @escaping (Result<Void, APIError>) -> Void)
    func infoGroup(userID: String, completion: @escaping (Result<InfoGroupRespose, APIError>) -> Void)
    func verifyGroupCode(groupCode: VerifyRequest, completion: @escaping(Result<VerifyResponse,APIError>) -> Void)
}

class GroupService: GroupServiceType {
   
    
    
    static let shared = GroupService()
    
    private let provider = MoyaProvider<GroupAPI>(
        plugins: [MoyaLoggingPlugin()]
    )
    
    func verifyGroupCode(groupCode: VerifyRequest, completion: @escaping (Result<VerifyResponse, APIError>) -> Void) {
        provider.requestWithValidation(.verify(verifyRequest: groupCode), completion: completion)
    }
    
    // MARK: - Join Group (Void 응답)
    func joinGroup(
        joinGroup: JoinGorupRequest,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        provider.requestWithValidation(
            .joinGroup(joinRequest: joinGroup),
            completion: completion
        )
    }
    
    // MARK: - Create Group (데이터 응답)
    func createGroup(
        groupRequest: CreateGroupRequest,
        completion: @escaping (Result<CreateGroupResponse, APIError>) -> Void
    ) {
        provider.requestWithValidation(
            .createGroup(createRequest: groupRequest),
            completion: completion
        )
    }
    
    // MARK: - Leave Group (Void 응답)
    func leaveGroup(
        userID: String,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        provider.requestWithValidation(
            .leveGroup(userID: userID),
            completion: completion
        )
    }
    
    // MARK: - Info Group (데이터 응답)
    func infoGroup(
        userID: String,
        completion: @escaping (Result<InfoGroupRespose, APIError>) -> Void
    ) {
        provider.requestWithValidation(
            .infoGroup(userID: userID),
            completion: completion
        )
    }
}
