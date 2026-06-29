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
        registerDeviceTokenToServer(token)
    }

    /// 수신한 디바이스 토큰을 서버에 등록한다.
    /// 로그인 바디 전송만으로는 토큰 도착 타이밍(비동기)·회전을 놓쳐 그룹 푸시가 누락되므로,
    /// 토큰을 받는 즉시(로그인 상태면) 서버에 갱신해 항상 최신값을 보유하게 한다.
    private func registerDeviceTokenToServer(_ token: String) {
        let userId = SharedUserDefaults.userID
        guard !userId.isEmpty else {
            print("ℹ️ user_id 없음(로그인 전) → 토큰은 로그인 시 전송됨")
            return
        }
        Task {
            do {
                try await APIClient.default.request(
                    try Endpoint(
                        path: "auth/device-token",
                        method: .post,
                        json: DeviceTokenRequest(userId: userId, deviceToken: token)
                    )
                )
                print("✅ 디바이스 토큰 서버 등록 완료")
            } catch {
                print("❌ 디바이스 토큰 서버 등록 실패: \(error)")
            }
        }
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for notifications: \(error.localizedDescription)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .list, .sound, .badge])
    }
}
