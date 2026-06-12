//
//  MainTabView.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import SwiftUI
import Domain
import Platform
import DesignSystem

public struct MainTabView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var mainTabViewModel: MainTabViewModel
    private let dependencies: AppDependencies
    @EnvironmentObject private var appState: AppState

    public init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _mainTabViewModel = StateObject(wrappedValue: MainTabViewModel(
            repository: dependencies.authRepository,
            userManager: dependencies.userManager
        ))
    }

    public var body: some View {
        VStack(spacing:0) {
            HStack(spacing: 24) {
                ForEach(WatchOutTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            DispatchQueue.main.async {
                                mainTabViewModel.selectedTab = tab
                            }
                            
                        }
                    }) {
                        tabButton(for: tab)
                    }
                    .fixedSize()
                }
                Spacer()
                Menu {
                    Button {
                        mainTabViewModel.showLogoutAlert = true
                    } label: {
                        Label("로그아웃", image: "LogOutImage")
                    }
                    
                    Button {
                        mainTabViewModel.showDeleteAccountAlert = true
                    } label: {
                        Label("탈퇴하기", systemImage: "person.crop.circle.badge.xmark")
                    }
                    
                } label: {
                    VStack {
                        Image("LogOutImage")
                        Capsule()
                            .frame(height: 3)
                            .foregroundColor(.clear)
                    }
                }
                .fixedSize()
                .alert("로그아웃 하시겠습니까?", isPresented: $mainTabViewModel.showLogoutAlert) {
                    Button("취소", role: .cancel) { }
                    Button("로그아웃", role: .destructive) {
                        appState.isLoggedIn = false
                        dependencies.tokenStore.clearAllTokens()
                        dependencies.userManager.clearUser()
                    }
                } message: {
                    Text("로그아웃 하시면 자동으로 그룹에서 강퇴됩니다.")
                }
                .alert("탈퇴하시겠습니까?", isPresented: $mainTabViewModel.showDeleteAccountAlert) {
                    Button("취소", role: .cancel) { }
                    Button("탈퇴하기", role: .destructive) {
                        mainTabViewModel.loginDelete() {
                            appState.isLoggedIn = false
                            dependencies.tokenStore.clearAllTokens()
                            dependencies.userManager.clearUser()
                        }
                        
                    }
                } message: {
                    Text("탈퇴하시면 계정이 영구적으로 삭제됩니다.")
                }
            }
            .padding(.horizontal, 33)
            .padding(.top)
            .background(Color.gray100)
            
            if mainTabViewModel.selectedTab == .homeView {
                HomeView(dependencies: dependencies)
                    .navigationBarBackButtonHidden()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if mainTabViewModel.selectedTab == .settingView {
                SettingView()
                    .navigationBarBackButtonHidden()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if mainTabViewModel.selectedTab == .reportView {
                ReportView()
                    .navigationBarBackButtonHidden()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    @ViewBuilder
    private func tabButton(for tab: WatchOutTab) -> some View {
        let isSelected = (mainTabViewModel.selectedTab == tab)
        
        VStack(alignment:.center,spacing: 8) {
            Text(tab.rawValue)
                .font(.pHeadline02)
                .foregroundColor(isSelected ? .black : .gray)
            
            if isSelected {
            Rectangle()
                    .frame(height: 3)
                    .foregroundColor(.black)
                
            } else {
                Rectangle()
                    .frame(height: 3)
                    .foregroundColor(.clear)
            }
        }
        
    }
}
