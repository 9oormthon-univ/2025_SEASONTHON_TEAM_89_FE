//
//  ContentView.swift
//  WatchOut
//
//  Created by 어재선 on 9/2/25.
//

import SwiftUI
import Domain
import Platform
import Features

struct ContentView: View {
    let dependencies: AppDependencies
    @EnvironmentObject private var appState: AppState

    var body: some View {
        if !appState.isLoggedIn {
            LoginView(dependencies: dependencies)
                .navigationBarBackButtonHidden()
        } else if !appState.isOnboardingCompleted {
            OnboardingView()
                .navigationBarBackButtonHidden()
        } else {
            MainTabView(dependencies: dependencies)
                .navigationBarBackButtonHidden()
        }
    }
}
