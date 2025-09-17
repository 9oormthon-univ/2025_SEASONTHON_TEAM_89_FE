//
//  GroupService.swift
//  WatchOut
//
//  Created by 어재선 on 9/16/25.
//

import Foundation
import Moya

protocol GroupServiceType {
    func CreateOroup(groupRequest: CreateGroupRequest, completion: @escaping (Result<CreateGroupResponse, Error>) -> Void)
}

class GroupService: GroupServiceType {
    
    static let shared = GroupService()
    var provider = MoyaProvider<GroupAPI>(plugins: [MoyaLoggingPlugin()])
    
    func CreateOroup(groupRequest: CreateGroupRequest, completion: @escaping (Result<CreateGroupResponse, any Error>) -> Void) {
        provider.request(.createGroup(createRequest: groupRequest)) { reslut in
            switch reslut {
            case .success(let response):
                do {
                    let responseData =  try JSONDecoder().decode(CreateGroupResponse.self, from: response.data)
                    completion(.success(responseData))
                    print("응답: \(responseData)")
                } catch {
                    print("디코딩 오류: \(error)")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                Log.network("실패", error) // 기존의 로그를 사용
                completion(.failure(error))
            }
        }
    }
    
    
}
