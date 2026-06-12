//
//  RootView.swift
//  WatchOut
//
//  Created by 어재선 on 3/5/26.
//

import SwiftUI
import Shared
import Domain
import Data
import Core
import FeatureMain
import FeatureGroup
import FeatureExperience
import FeatureSetting

struct RootView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var appState = AppState(
        isLoggedIn: TokenManager.shared.loadAccessToken().map { !$0.isEmpty } ?? false,
        isOnboardingCompleted: SharedUserDefaults.isOnboarding
    )
    @StateObject private var userManager = UserManager.shared

    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            ContentView()
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
            MainTabView()
                .navigationBarBackButtonHidden()
        case .exprienceView:
            ExperienceView()
                .navigationBarBackButtonHidden()
        case .createGroupView:
            CreateGroupView()
                .navigationBarBackButtonHidden()
        case .joinGroupView:
            JoinGroupView()
                .navigationBarBackButtonHidden()
        case .managementGroupView:
            ManagementGroupView()
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
