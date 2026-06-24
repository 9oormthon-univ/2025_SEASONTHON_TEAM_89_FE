//
//  AppDelegate.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import KakaoSDKAuth
import UIKit
import Data
import Platform

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        clearKeychainOnFreshInstall()
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                print("Push Permission Granted")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("Push Permission Denied")
            }
        }
        
        return true
    }

    /// 앱 재설치 감지 시 Keychain 정리.
    /// iOS Keychain은 앱 삭제 후에도 남아, 잔존 토큰으로 isLoggedIn=true가 되어
    /// 로그인 화면을 건너뛰는 문제를 방지한다. (UserDefaults 플래그는 삭제 시 함께 지워짐)
    private func clearKeychainOnFreshInstall() {
        guard !SharedUserDefaults.hasLaunchedBefore else { return }
        TokenManager.shared.clearAllTokens()
        SharedUserDefaults.hasLaunchedBefore = true
        print("🧹 첫 실행 감지: 잔존 Keychain 토큰/유저 정리 완료")
    }


    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("✅ Device Token: \(token)")
        TokenManager.shared.saveDeviceToken(token)
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for notifications: \(error.localizedDescription)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .list, .sound, .badge])
    }
}
