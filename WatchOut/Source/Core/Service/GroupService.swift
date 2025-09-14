//
//  GroupService.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation


enum groupApiType: String {
    case create
    case join
    case pending
    case leave
}
class GroupService {
    // API의 기본 URL
    private let urlString = "https://wiheome.ajb.kr/api/family_group/create"
    
    // 그룹 생성
    func createGroup(groupName: String, userID: String, userName: String  ) async throws -> CreateGorupResponse {
        
        // 1. 서버로 보낼 데이터 생성
        let requestBody = CreateGorupRequest(groupName: groupName, userID: userID, userName: userName)
        
        // 2. APIService를 사용하여 POST 요청.
        // 보낼 타입은 ChatRequest, 받을 타입은 ChatResponse로 명시.
        let response: CreateGorupResponse = try await APIService.shared.post(
            urlString: urlString,
            body: requestBody
        )
        
        // 3. 받은 응답에서 실제 필요한 result 객체만 반환
        return response
        
    }
    // 그룹 참여
    func joinGroup(joinCode: String, userID: String, userName: String  ) async throws -> JoinGorupResponse {
        // 1. 서버로 보낼 데이터 생성
        let requestBody = JoinGorupRequest(joinCode: joinCode, userID: userID, userName: userName)
        
        // 2. APIService를 사용하여 POST 요청.
        // 보낼 타입은 ChatRequest, 받을 타입은 ChatResponse로 명시.
        let response: JoinGorupResponse = try await APIService.shared.post(
            urlString: urlString,
            body: requestBody
        )
        // 3. 받은 응답에서 실제 필요한 result 객체만 반환
        return response
        
    }
    
    
    
}

