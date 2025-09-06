//
//  MainTabView.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var mainTabViewModel: MainTabViewModel
    var body: some View {
        VStack {
            
            
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button(action: {
                        // 탭을 누르면 selectedTab 상태를 변경
                        if tab == .exprienceView {
                            pathModel.paths.append(.exprienceView)
                        } else {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                mainTabViewModel.selectedTab = tab
                            }
                        }
                        
                    }) {
                        tabButton(for: tab)
                    }
                    .buttonStyle(.plain) // 버튼의 기본 회색 배경 제거
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .background(Color.gray100)
            
            if mainTabViewModel.selectedTab == .homeView {
                HomeView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if mainTabViewModel.selectedTab == .settingView {
                WatingView()
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
            
            // 선택된 탭에만 밑줄을 보여주고 애니메이션 적용
            if isSelected {
                Capsule()
                    .frame(height: 3)
                    .foregroundColor(.black)
                
            } else {
                // 공간을 차지하기 위한 투명한 밑줄
                Capsule().frame(height: 3).foregroundColor(.clear)
            }
        }
    }
    
}

#Preview {
    MainTabView()
}
