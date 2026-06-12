//
//  RootView.swift
//  WatchOut
//
//  Created by 어재선 on 3/5/26.
//

import SwiftUI
import DesignSystem
import Domain
import Data
import Platform
import Presentation

struct RootView: View {
    // Composition Root — 구현체 선택은 이 한 곳에서만
    private let dependencies = AppDependencies(
        authRepository: AuthRepositoryImpl(),
        groupRepository: GroupRepositoryImpl(),
        tokenStore: TokenManager.shared,
        userManager: UserManager.shared
    )

    @StateObject private var pathModel = PathModel()
    @StateObject private var appState = AppState(
        isLoggedIn: TokenManager.shared.loadAccessToken().map { !$0.isEmpty } ?? false,
        isOnboardingCompleted: SharedUserDefaults.isOnboarding
    )
    @StateObject private var userManager = UserManager.shared

    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            ContentView(dependencies: dependencies)
                .navigationDestination(for: PathType.self) { pathType in
                    destination(for: pathType)
                }
        }
        .environmentObject(pathModel)
        .environmentObject(appState)
        .environmentObject(userManager)
        .onAppear(perform: UserManager.shared.loadUserFromUserDefaults)
    }

    @ViewBuilder
    private func destination(for pathType: PathType) -> some View {
        switch pathType {
        case .mainTabView:
            MainTabView(dependencies: dependencies)
                .navigationBarBackButtonHidden()
        case .exprienceView:
            ExperienceView()
                .navigationBarBackButtonHidden()
        case .createGroupView:
            CreateGroupView(dependencies: dependencies)
                .navigationBarBackButtonHidden()
        case .joinGroupView:
            JoinGroupView(dependencies: dependencies)
                .navigationBarBackButtonHidden()
        case .managementGroupView:
            ManagementGroupView(dependencies: dependencies)
                .navigationBarBackButtonHidden()
        case .planView:
            PlanView()
                .navigationBarBackButtonHidden()
        case .waitingView:
            WaitingView()
                .navigationBarBackButtonHidden()
        }
    }
}
