//
//  AppState.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation

public final class AppState: ObservableObject {
    @Published public var isLoggedIn: Bool
    @Published public var isOnboardingCompleted: Bool

    public init(isLoggedIn: Bool = false, isOnboardingCompleted: Bool = false) {
        self.isLoggedIn = isLoggedIn
        self.isOnboardingCompleted = isOnboardingCompleted
    }
}
