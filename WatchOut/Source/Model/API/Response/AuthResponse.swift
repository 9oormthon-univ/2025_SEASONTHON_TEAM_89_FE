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
}
