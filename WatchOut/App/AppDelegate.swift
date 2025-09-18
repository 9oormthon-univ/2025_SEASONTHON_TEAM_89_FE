//
//  AppDelegate.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import KakaoSDKAuth
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // 앱이 처음 실행될 때 호출되는 함수
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // UNUserNotificationCenter의 대리자(delegate)를 self로 설정합니다.
        // 이걸 설정해야 아래 함수들이 호출됩니다.
        UNUserNotificationCenter.current().delegate = self
        
        // 사용자에게 알림 권한을 요청합니다.
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                print("Push Permission Granted")
                // 권한이 허용되면, APNs에 디바이스 토큰을 등록하도록 요청합니다.
                // UI 관련 작업이므로 메인 스레드에서 실행합니다.
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("Push Permission Denied")
            }
        }
        
        return true
    }
    
    // 디바이스 토큰 등록에 성공했을 때 호출
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("✅ Device Token: \(token)")
        TokenManager.shared.saveDeviceToken(token)
        // 이 토큰을 백엔드 서버로 전송하는 로직이 필요합니다.
    }
    
    // 디바이스 토큰 등록에 실패했을 때 호출
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for notifications: \(error.localizedDescription)")
    }
    
    // ✅ 앱이 포그라운드(켜진 상태)에서 알림을 받았을 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 앱이 켜져 있을 때도 알림을 표시하도록 설정합니다.
        // 만약 이 코드가 없으면 앱이 켜져 있을 때는 푸시 알림이 사용자에게 보이지 않습니다.
        completionHandler([.banner, .list, .sound, .badge])
    }
}
