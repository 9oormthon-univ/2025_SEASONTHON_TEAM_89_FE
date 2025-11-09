//
//  MainTabViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import Foundation


class MainTabViewModel: ObservableObject {
    @Published var selectedTab: Tab
    @Published var showLogoutAlert: Bool = false
    @Published var showDeleteAccountAlert: Bool = false
    
    init(selectedTab: Tab = .homeView) {
        self.selectedTab = selectedTab
    }
}
