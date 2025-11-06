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
        
        VStack {
            if !appState.isLoggedIn {
        
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
