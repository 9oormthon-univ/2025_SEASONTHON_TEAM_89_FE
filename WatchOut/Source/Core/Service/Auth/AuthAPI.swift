//
//  AuthAPI.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation
import Moya

// 'Auth' 관련 API를 모아놓은 enum입니다.
enum AuthAPI {
    case kakaoLogin(token: String)
    // case appleLogin(token: String) // 추후 애플 로그인 추가 시
    // case tokenRefresh(refreshToken: String) // 추후 토큰 리프레시 추가 시
}

extension AuthAPI: TargetType {
    // 1. 서버의 Base URL
    var baseURL: URL {
        // 🚨 반드시 본인의 서버 주소로 변경해야 합니다.
        return URL(string: "https://wiheome.ajb.kr/api/auth")!
    }

    // 2. 각 API의 경로 (Path)
    var path: String {
        switch self {
        case .kakaoLogin:
            return "/kakao/token" // 카카오 로그인 API 경로
        }
    }

    // 3. HTTP Method (get, post, put, delete)
    var method: Moya.Method {
        switch self {
        case .kakaoLogin:
            return .post
        }
    }

    // 4. 요청에 포함할 파라미터
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let token):
            // Request Body에 JSON 형태로 들어갈 파라미터
            let parameters: [String: Any] = ["access_token": token]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    // 5. HTTP Header
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
