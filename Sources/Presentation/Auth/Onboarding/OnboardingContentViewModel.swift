//
//  OnboardingContentViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import Foundation
import Platform

// MARK: - OnboardingContentViewModel
final class OnboardingContentViewModel: ObservableObject {
    // 첫 프레임부터 실제 키보드 활성 상태로 시작 → FirstView가 깜빡이고 사라지는 현상 방지.
    @Published private var isKeyboardEnabled = KeyboardPermissionManager.isKeyboardEnabled()
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
