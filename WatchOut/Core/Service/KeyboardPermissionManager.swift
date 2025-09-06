//
//  KeyboardPermissionManager.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import UIKit

struct KeyboardPermissionManager {
    

    static func isKeyboardEnabled() -> Bool {
           // activeInputModes는 항상 메인 스레드에서 접근하는 것이 가장 안전합니다.
           guard Thread.isMainThread else {
               print("Warning: isKeyboardEnabled() was called from a background thread.")
               return false
           }
           
           let activeKeyboards = UITextInputMode.activeInputModes
        
           print("activeKeyboards: \(activeKeyboards)")
           let isEnabled = activeKeyboards.contains { inputMode in

               // ✅ 공식 속성인 primaryLanguage만을 사용하여 확인합니다.
               // 이 방법은 두 종류의 키보드 객체 모두에서 안전하게 동작합니다.
  
               if let language = inputMode.primaryLanguage {
                   // primaryLanguage 문자열에 우리 키보드의 번들 ID가 포함되어 있는지 검사
                   print(language)
                   return language.contains("watchout")
               }
               return false
           }
           
           print("키보드 활성화 상태: \(isEnabled)")
           return isEnabled
       }
    
    
    /// 사용자를 '설정 > [내 앱 이름]' 화면으로 바로 보내주는 함수
    static func openAppSettings() async {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            // Ask the system to open that URL.
            print("\(url)")
            await UIApplication.shared.open(url)
        }    }
}
