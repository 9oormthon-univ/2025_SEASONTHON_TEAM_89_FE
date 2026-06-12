//
//  MainTabViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import Foundation
import Combine
import Shared
import Domain
import Data
import Core

class MainTabViewModel: ObservableObject {
    @Published var selectedTab: WatchOutTab
    @Published var showLogoutAlert: Bool = false
    @Published var showDeleteAccountAlert: Bool = false
    @Published var isLoading: Bool = false

    private let repository: AuthRepository
    private let userManager: UserManager

    init(
        selectedTab: WatchOutTab = .homeView,
        repository: AuthRepository = AuthRepositoryImpl(),
        userManager: UserManager = .shared
    ) {
        self.selectedTab = selectedTab
        self.repository = repository
        self.userManager = userManager
    }

    func loginDelete(completion: @escaping () -> Void) {
        guard let userId = userManager.currentUser?.userId else { return }

        isLoading = true
        Task { @MainActor in
            do {
                try await repository.deleteAccount(userId: userId)
                isLoading = false
                completion()
            } catch {
                Log.error("회원 탈퇴 실패: \(error)")
                isLoading = false
            }
        }
    }
}
