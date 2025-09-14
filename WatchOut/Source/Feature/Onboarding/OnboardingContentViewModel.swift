//
//  OnboardingContentViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import Foundation

// MARK: - OnboardingContentViewModel
final class OnboardingContentViewModel: ObservableObject {
    @Published private var isKeyboardEnabled = false
    @Published private var isFirstSetting = false
}

// MARK: - Public Methods
extension OnboardingContentViewModel {
    func checkKeyboardStatus() {
        let status = KeyboardPermissionManager.isKeyboardEnabled()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.isKeyboardEnabled != status {
                self.isKeyboardEnabled = status
            }
        }
    }
    
    func getIsKeyboardEnabled() -> Bool {
        return isKeyboardEnabled
    }
    
    func getIsFirstSetting() -> Bool {
        return isFirstSetting
    }
}
