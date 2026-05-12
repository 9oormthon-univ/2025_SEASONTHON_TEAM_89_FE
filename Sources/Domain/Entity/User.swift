//
//  UserModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation

public struct User: Codable {
    public let userId: String
    public let kakaoId: Int
    public let nickname: String
    public let profileImage: String

    public enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case kakaoId = "kakao_id"
        case nickname
        case profileImage = "profile_image"
    }
    
    public init(userId: String, kakaoId: Int, nickname: String, profileImage: String) {
        self.userId = userId
        self.kakaoId = kakaoId
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
