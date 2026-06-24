//
//  KeyboardPermissionManager.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import UIKit

public struct KeyboardPermissionManager {

    /// 키보드 익스텐션 번들 ID. 앱 번들 ID(com.jaesuneo.WatchOut)에서 파생.
    private static var keyboardBundleID: String {
        (Bundle.main.bundleIdentifier ?? "") + ".WatchOutkeyboard"
    }

    /// 사용자가 설정에서 우리 키보드를 추가했는지 여부.
    /// iOS는 설치된 서드파티 키보드의 번들 ID를 UserDefaults의 "AppleKeyboards"에 보관한다.
    public static func isKeyboardEnabled() -> Bool {
        guard let keyboards = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else {
            Log.debug("AppleKeyboards 목록을 읽을 수 없음")
            return false
        }
        let isEnabled = keyboards.contains(keyboardBundleID)
        Log.debug("키보드 활성화 상태: \(isEnabled) (id: \(keyboardBundleID))")
        return isEnabled
    }

    public static func openAppSettings() async {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        await MainActor.run {
            UIApplication.shared.open(url)
        }
    }
}
