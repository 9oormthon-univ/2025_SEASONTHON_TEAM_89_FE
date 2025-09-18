//
//  GroupAPI.swift
//  WatchOut
//
//  Created by 어재선 on 9/16/25.
//

import Foundation
import Moya

enum GroupAPI{
    case createGroup(createRequest: CreateGroupRequest)
    case joinGroup(joinRequest: JoinGorupRequest)
    case leveGroup(userID: String)
    
//    case ManageMentGroup
//    case WaitingGroup
}

extension GroupAPI: TargetType{
    var baseURL: URL {
        return URL(string: "https://wiheome.ajb.kr/api/family_group")!
    }
    
    var path: String {
        switch self {
            
        case .createGroup:
            return "/create"
        case .joinGroup:
            return "/join"
//        case .ManageMentGroup:
//             
//        case .WaitingGroup:
//
        case .leveGroup(let userID):
            return "/leave/\(userID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .createGroup:
            return .post
        case .joinGroup:
            return .post
        case .leveGroup(_):
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createGroup(let request):
            return .requestJSONEncodable(request)
        case .joinGroup(let request):
            return .requestJSONEncodable(request)
        case .leveGroup(userID: let userID):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    
}
