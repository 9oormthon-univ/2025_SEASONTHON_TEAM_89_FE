//
//  KeyboardPermissionManager.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import UIKit

/// WatchOut 키보드 확장 기능의 권한 상태를 관리하는 매니저
struct KeyboardPermissionManager {
    
    /// 현재 WatchOut 키보드가 시스템에서 활성화되어 있는지 확인
    /// - Returns: 키보드가 활성화되어 있으면 true, 그렇지 않으면 false
    static func isKeyboardEnabled() -> Bool {
        // UITextInputMode.activeInputModes는 메인 스레드에서만 안전하게 접근 가능
        guard Thread.isMainThread else {
            print("Warning: isKeyboardEnabled() was called from a background thread.")
            return false
        }
        
        let activeKeyboards = UITextInputMode.activeInputModes
        print("activeKeyboards: \(activeKeyboards)")
        
        let isEnabled = activeKeyboards.contains { inputMode in
            // primaryLanguage 속성을 사용하여 WatchOut 키보드 확인
            // 이 방법은 모든 키보드 객체에서 안전하게 동작함
            if let language = inputMode.primaryLanguage {
                print(language)
                // 번들 ID에 "watchout"이 포함되어 있는지 확인
                return language.contains("watchout")
            }
            return false
        }
        
        print("키보드 활성화 상태: \(isEnabled)")
        return isEnabled
    }
    
    /// 사용자를 시스템 설정의 해당 앱 설정 화면으로 이동시킴
    /// 키보드 권한을 활성화할 수 있도록 안내하기 위해 사용
    static func openAppSettings() async {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        print("Opening app settings: \(url)")
        
        // UIApplication.open은 반드시 메인 스레드에서 호출되어야 함
        await MainActor.run {
            UIApplication.shared.open(url)
        }
    }
}

