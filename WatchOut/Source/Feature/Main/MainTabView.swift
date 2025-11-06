//
//  MainTabView.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var mainTabViewModel = MainTabViewModel()
    @EnvironmentObject private var appState: AppState
    var body: some View {
        VStack {
            
            
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button(action: {
                        
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            mainTabViewModel.selectedTab = tab
                            
                        }
                        
                    }) {
                        tabButton(for: tab)
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
                Button(action: {
                    appState.isLoggedIn = false
                    TokenManager.shared.clearAllTokens()
                    UserManager.shared.clearUser()
                }, label: {
                    VStack {
                        Image("LogOutImage")
                        Capsule().frame(height: 3).foregroundColor(.clear)
                    }
                    
                     
                })
            }
            .padding(.horizontal)
            .padding(.top)
            .background(Color.gray100)
            
            if mainTabViewModel.selectedTab == .homeView {
                HomeView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if mainTabViewModel.selectedTab == .settingView {
                SettingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if mainTabViewModel.selectedTab == .reportView {
                ReportView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    @ViewBuilder
    private func tabButton(for tab: Tab) -> some View {
        let isSelected = (mainTabViewModel.selectedTab == tab)
        
        VStack(spacing: 8) {
            Text(tab.rawValue)
                .font(.pHeadline02)
                .foregroundColor(isSelected ? .black : .gray)
            
            if isSelected {
                Capsule()
                    .frame(height: 3)
                    .foregroundColor(.black)
                
            } else {
                Capsule().frame(height: 3).foregroundColor(.clear)
            }
        }
    }
    
}

#Preview {
    MainTabView()
}
