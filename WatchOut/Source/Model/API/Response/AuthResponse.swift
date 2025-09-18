//
//  AuthResponse.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String

    // 만약 서버의 key가 access_token 같은 snake_case라면 아래 코드를 추가하세요.
    // enum CodingKeys: String, CodingKey {
    //     case accessToken = "access_token"
    //     case refreshToken = "refresh_token"
    // }
}
