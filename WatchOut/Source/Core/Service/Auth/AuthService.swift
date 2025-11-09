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

final class AuthService {
    private let provider = MoyaProvider<AuthAPI>(plugins: [NetworkLoggerPlugin()])

    // ⬇️ 반환 타입을 새로운 LoginResponse로 변경합니다.
    func kakaoLogin(token: String) -> AnyPublisher<LoginResponse, Error> {
        return provider.requestPublisher(.kakaoLogin(request: KakaoLoginRequest(accessToken: token, DeviceType: TokenManager.shared.loadDeviceToken() ?? "시뮬레이터")))
            .tryMap { response in
                guard (200...299).contains(response.statusCode) else {
                    throw MoyaError.statusCode(response)
                }
                // ⬇️ 디코딩할 모델을 LoginResponse.self로 변경합니다.
                let data = try response.map(LoginResponse.self)
                UserManager.shared.setCurrentUser(data.user)
                return data
            }
            .eraseToAnyPublisher()
    }
}
