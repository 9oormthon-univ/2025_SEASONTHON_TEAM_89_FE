//
//  SharedUserDefaults.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import SwiftUI
import Foundation

// 앱과 키보드 확장 프로그램이 함께 사용할 UserDefaults 관리자
struct SharedUserDefaults {
    
    // Xcode에서 설정한 App Group ID (본인의 ID로 변경 필수!)
    private static let appGroupID = "group.com.eo.watchout.app"
    
    // 공유 UserDefaults 인스턴스
    static let shared = UserDefaults(suiteName: appGroupID)!
    
    // 설정 키를 Enum으로 관리
    enum SettingsKey: String {
        case notificationsEnabled = "isNotificationsEnabled"
        case hapticFeedbackEnabled = "isHapticFeedbackEnabled"
        case warningColorLevel1 = "warningColorLevel1"
        case warningColorLevel2 = "warningColorLevel2"
        case tutorialEnabled = "isTutorial"
        case onboarding = "isOnboarding"
        case riskLevel2Count = "riskLevel2Count"
        case riskLevel3Count = "riskLevel3Count"
        case userID = "userID"
        case groupCode = "groupCode"
        case joinId = "joinId"
        case createGroup = "isCreateGroup"
    }
    
    //MARK: - CreateCroup
    static var isCreateGroup: Bool {
        get {
            return shared.object(forKey: SettingsKey.createGroup.rawValue) as? Bool ?? false
        } set {
            shared.set(newValue, forKey: SettingsKey.createGroup.rawValue)
        }
    }
    
    
    //MARK: - ShardID
    static var joinId: String {
        get {
            return shared.object(forKey: SettingsKey.joinId.rawValue) as? String ?? ""
        } set {
            shared.set(newValue, forKey: SettingsKey.joinId.rawValue)
        }
    }
    
    //MARK: - GroupCode
    static var groupCode: String {
        get {
            return shared.object(forKey: SettingsKey.groupCode.rawValue) as? String ?? ""
        } set {
            shared.set(newValue, forKey: SettingsKey.groupCode.rawValue)
        }
    }
    
    
    //MARK: - UserID
    static var userID: String {
        get {
            if let existingUserID = shared.object(forKey: SettingsKey.userID.rawValue) as? String {
                return existingUserID
            } else {
                // Generate new UUID and save it
                let newUserID = UUID().uuidString
                shared.set(newUserID, forKey: SettingsKey.userID.rawValue)
                return newUserID
            }
        } set {
            shared.set(newValue, forKey: SettingsKey.userID.rawValue)
        }
    }
    
    //MARK: - riskLevel2
    static var riskLevel2Count: Int {
        get {
            return shared.object(forKey: SettingsKey.riskLevel2Count.rawValue) as? Int ?? 0
        } set {
            shared.set(newValue, forKey: SettingsKey.riskLevel2Count.rawValue)
        }
    }
    //MARK: - riskLevel3
    static var riskLevel3Count: Int {
        get {
            return shared.object(forKey: SettingsKey.riskLevel3Count.rawValue) as? Int ?? 0
        } set {
            shared.set(newValue, forKey: SettingsKey.riskLevel3Count.rawValue)
        }
    }
    //MARK: - 온보딩 설정
    static var isOnboarding: Bool {
        get {
            return shared.object(forKey: SettingsKey.onboarding.rawValue) as? Bool ?? false
        } set {
            shared.set(newValue, forKey: SettingsKey.onboarding.rawValue)
        }
    }
    
    // MARK: - 설정 프로퍼티 (Get/Set)
    
    static var isTutorial: Bool {
        get {
            return shared.object(forKey: SettingsKey.tutorialEnabled.rawValue) as? Bool ?? false
        } set {
            shared.set(newValue, forKey: SettingsKey.tutorialEnabled.rawValue)
        }
    }
    
    /// 알림 설정 (켜기/끄기)
    static var isNotificationsEnabled: Bool {
        get {
            // 기본값: 켜기(true)
            return shared.object(forKey: SettingsKey.notificationsEnabled.rawValue) as? Bool ?? true
        }
        set {
            shared.set(newValue, forKey: SettingsKey.notificationsEnabled.rawValue)
        }
    }
    
    /// 키보드 진동(햅틱 피드백) 설정
    static var isHapticFeedbackEnabled: Bool {
        get {
            // 기본값: 켜기(true)
            return shared.object(forKey: SettingsKey.hapticFeedbackEnabled.rawValue) as? Bool ?? true
        }
        set {
            shared.set(newValue, forKey: SettingsKey.hapticFeedbackEnabled.rawValue)
        }
    }
    
    /// 경고 색상 1단계 (색상 이름을 String으로 저장)
    static var warningColorLevel1: String {
        get {
            // 기본값: "orange"
            return shared.string(forKey: SettingsKey.warningColorLevel1.rawValue) ?? "orange"
        }
        set {
            shared.set(newValue, forKey: SettingsKey.warningColorLevel1.rawValue)
        }
    }
    
    /// 경고 색상 2단계 (색상 이름을 String으로 저장)
    static var warningColorLevel2: String {
        get {
            // 기본값: "red"
            return shared.string(forKey: SettingsKey.warningColorLevel2.rawValue) ?? "red"
        }
        set {
            shared.set(newValue, forKey: SettingsKey.warningColorLevel2.rawValue)
        }
    }
    
    // MARK: - Helper (저장된 문자열을 SwiftUI Color로 변환)
    
    /// 저장된 색상 이름 문자열을 실제 SwiftUI Color 객체로 변환해주는 함수
    static func color(forName name: String) -> Color {
        switch name.lowercased() {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "blue": return .blue
        case "purple": return .purple
        default: return .orange // 알 수 없는 값이면 기본색 반환
        }
    }
}
