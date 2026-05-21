//
//  AuthService.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation
import Moya
import CombineMoya
import Combine

public final class AuthService {
    private let provider = MoyaProvider<AuthAPI>(plugins: [NetworkLoggerPlugin()])
    public init() { }
    public func kakaoLogin(token: String) -> AnyPublisher<LoginResponse, Error> {
        return provider.requestPublisher(.kakaoLogin(request: KakaoLoginRequest(accessToken: token, deviceToken: TokenManager.shared.loadDeviceToken() ?? "시뮬레이터")))
            .tryMap { response in
                guard (200...299).contains(response.statusCode) else {
                    throw MoyaError.statusCode(response)
                }
                
                let data = try response.map(LoginResponse.self)
                UserManager.shared.setCurrentUser(data.user)
                return data
            }
            .eraseToAnyPublisher()
    }
    
    public func kakaoDelete(userId: String) -> AnyPublisher<Void, Error> {
        return provider.requestPublisher(.kakaoDelete(request:KakaoDeleteRequest(userId: userId)))
            .tryMap { response in
                guard (200...299).contains(response.statusCode) else {
                    throw MoyaError.statusCode(response)
                }
            }
            .eraseToAnyPublisher()
       
    }
    
}
