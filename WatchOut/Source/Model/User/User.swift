//
//  UserModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation

// 응답 JSON 내부의 "user" 객체를 위한 모델
struct User: Codable {
    let userId: String
    let kakaoId: Int
    let nickname: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case kakaoId = "kakao_id"
        case nickname
        case profileImage = "profile_image"
    }
}
