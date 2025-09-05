//
//  AppDelegate.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 앱이 시작될 때 UNUserNotificationCenter의 대리자(delegate)를 self로 설정합니다.
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // ✅ 이 함수가 핵심입니다!
    // 앱이 포그라운드(켜진 상태)에 있을 때 알림을 받으면 호출됩니다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 알림을 어떻게 표시할지 시스템에 알려줍니다.
        // .banner: 상단에 배너 표시
        // .sound: 알림 소리 재생
        // .badge: 앱 아이콘에 숫자 표시
        completionHandler([.banner, .sound, .badge])
    }
}
