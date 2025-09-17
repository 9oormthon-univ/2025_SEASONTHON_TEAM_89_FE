//
//  LoginRespose.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation

// 서버 응답 전체를 감싸는 모델
struct LoginResponse: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let user: User
    let isNewUser: Bool

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case user
        case isNewUser = "is_new_user"
    }
}

// 응답 JSON 내부의 "user" 객체를 위한 모델
struct User: Codable {
    let kakaoId: Int
    let nickname: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case kakaoId = "kakao_id"
        case nickname
        case profileImage = "profile_image"
    }
}
