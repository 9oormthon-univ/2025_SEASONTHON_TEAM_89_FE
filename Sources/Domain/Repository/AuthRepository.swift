//
//  AuthRepository.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation

public protocol AuthRepository {
    func loginWithKakao(accessToken: String, deviceToken: String?) async throws -> LoginResult
    func deleteAccount(userId: String) async throws
}
