//
//  KeyboardPermissionManager.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import UIKit

struct KeyboardPermissionManager {
    
    static func isKeyboardEnabled() -> Bool {
        guard Thread.isMainThread else {
            print("Warning: isKeyboardEnabled() was called from a background thread.")
            return false
        }
        
        let activeKeyboards = UITextInputMode.activeInputModes
        print("activeKeyboards: \(activeKeyboards)")
        
        let isEnabled = activeKeyboards.contains { inputMode in
        
            if let language = inputMode.primaryLanguage {
                print(language)
                return language.contains("watchout")
            }
            return false
        }
        
        print("키보드 활성화 상태: \(isEnabled)")
        return isEnabled
    }

    static func openAppSettings() async {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        print("Opening app settings: \(url)")
        
        await MainActor.run {
            UIApplication.shared.open(url)
        }
    }
}

