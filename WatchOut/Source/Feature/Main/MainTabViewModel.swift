//
//  MainTabViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import Foundation
import Combine

class MainTabViewModel: ObservableObject {
    @Published var selectedTab: Tab
    @Published var showLogoutAlert: Bool = false
    @Published var showDeleteAccountAlert: Bool = false
    
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading: Bool = false

    
    
    init(selectedTab: Tab = .homeView) {
        self.selectedTab = selectedTab
    }
    
    func loginDelete(completion: @escaping () -> Void) {
        guard let userId = UserManager.shared.currentUser?.userId else { return }
        
        requestDeleteServer(with: userId ) { [weak self] isDelete in
            guard let self = self else { return }
            if isDelete {
                completion()
            }
        }
    }
    
    private func requestDeleteServer(with userId: String, completion: @escaping (_ success: Bool) -> Void) {
        isLoading = true
        authService.kakaoDelte(userId: userId)
            .sink { [weak self]
                result in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("서버 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                }
            } receiveValue: { _ in
                completion(true)
            }
            .store(in: &cancellables)
    }
    
}
