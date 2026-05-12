//
//  LoginRespose.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation
import Domain

public struct LoginResponse: Codable {
    public let accessToken: String
    public let tokenType: String
    public let expiresIn: Int
    public let user: User
    public let isNewUser: Bool

    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case user
        case isNewUser = "is_new_user"
    }
}

