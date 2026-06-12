//
//  LoginResult.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation

public struct LoginResult: Equatable {
    public let accessToken: String
    public let user: User
    public let isNewUser: Bool

    public init(accessToken: String, user: User, isNewUser: Bool) {
        self.accessToken = accessToken
        self.user = user
        self.isNewUser = isNewUser
    }
}
