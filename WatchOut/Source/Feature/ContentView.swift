//
//  ContentView.swift
//  WatchOut
//
//  Created by 어재선 on 9/2/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var userManger = UserManager.shared
    
    var body: some View {
        // AppState의 값에 따라 적절한 뷰를 보여줌
        VStack {
            if !appState.isLoggedIn {
                // 1. 로그인이 안되어 있으면 LoginView를 보여줌
                LoginView()
                    .environmentObject(appState)
            } else {
                OnboardingView()
                    .environmentObject(appState)
            }
        }
        .environmentObject(userManger)
    }
}

#Preview {
    ContentView()
}
