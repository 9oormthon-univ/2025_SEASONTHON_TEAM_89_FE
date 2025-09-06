//
//  OnboardingViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import Foundation


class OnboardingContentViewModel: ObservableObject {
    @Published private var isKeyboardEnabled = false
    @Published private var isFirstSetting = false
    
}


extension OnboardingContentViewModel {
    
    func checkKeyboardStatus() {
        // 1. isKeyboardEnabled() 함수를 호출하는 것은 어떤 스레드에서 해도 비교적 안전합니다.
        let status = KeyboardPermissionManager.isKeyboardEnabled()
        print(status)
        // 2. ✅ 하지만 그 결과로 UI 상태(@State)를 바꾸는 것은 반드시 메인 스레드에서 해야 합니다.
        DispatchQueue.main.async {
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
