//
//  AppDependencies.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation
import Domain

/// 앱의 의존성 묶음. composition root(앱 진입점)에서 한 번만 조립해 화면으로 흘려보낸다.
/// Presentation은 Domain 프로토콜만 알며, 구현체 선택은 전적으로 조립 지점의 책임이다.
public struct AppDependencies {
    public let authRepository: AuthRepository
    public let groupRepository: GroupRepository
    public let tokenStore: TokenStore
    public let userManager: UserManager

    public init(
        authRepository: AuthRepository,
        groupRepository: GroupRepository,
        tokenStore: TokenStore,
        userManager: UserManager
    ) {
        self.authRepository = authRepository
        self.groupRepository = groupRepository
        self.tokenStore = tokenStore
        self.userManager = userManager
    }
}
