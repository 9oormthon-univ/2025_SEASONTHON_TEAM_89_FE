//
//  HomeViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 11/9/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var risk2Count: Int = 0
    @Published var risk3Count: Int = 0
    @Published var username:String = "위허메"
    
    init() {
        UserManager.shared.loadUserFromUserDefaults()
    }
    
    func loadData() {
        UserManager.shared.loadUserFromUserDefaults()
        
        if let username = UserManager.shared.currentUser?.nickname {
            self.username = username
        }
        
        risk2Count = SharedUserDefaults.riskLevel2Count
        risk3Count = SharedUserDefaults.riskLevel3Count
    }
    
}
