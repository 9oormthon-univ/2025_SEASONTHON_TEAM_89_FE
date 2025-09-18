//
//  GroupService.swift
//  WatchOut
//
//  Created by 어재선 on 9/16/25.
//

import Foundation
import Moya

protocol GroupServiceType {
    func CreateGroup(groupRequest: CreateGroupRequest, completion: @escaping (Result<CreateGroupResponse, Error>) -> Void)
}

class GroupService: GroupServiceType {
    
    static let shared = GroupService()
    var provider = MoyaProvider<GroupAPI>(plugins: [MoyaLoggingPlugin()])
    
    
    func joinGroup(joinGroup: JoinGorupRequest, completion: @escaping(Result<Void, any Error>) -> Void ){
        provider.request(.joinGroup(joinRequest: joinGroup)) { result in
            switch result {
            case .success(_):
                print("나가기 및 삭제 성공")
                completion(.success(()))
            case .failure(let error):
                print("나가기 및 삭제 실패 \(error)")
                completion(.failure(error))
            }
            
        }
    }
    
    func CreateGroup(groupRequest: CreateGroupRequest, completion: @escaping (Result<CreateGroupResponse, any Error>) -> Void) {
        provider.request(.createGroup(createRequest: groupRequest)) { result in
            switch result {
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
    
    func leaveGrou(userID: String, completion: @escaping(Result<Void, any Error>) -> Void ){
        provider.request(.leveGroup(userID: userID)) { result in
            switch result {
            case .success(_):
                print("나가기 및 삭제 성공")
                completion(.success(()))
            case .failure(let error):
                print("나가기 및 삭제 실패 \(error)")
                completion(.failure(error))
            }
            
        }
    }
    
    func infoGroup(userID: String, completion: @escaping(Result<InfoGroupRespose, any Error>) -> Void) {
        provider.request(.infoGroup(userID: userID)) { result in
            switch result {
            case .success(let response):
                do {
                    let responseData = try JSONDecoder().decode(InfoGroupRespose.self, from: response.data)
                    completion(.success(responseData))
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
