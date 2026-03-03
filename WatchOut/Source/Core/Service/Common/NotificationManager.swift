//
//  NotificationManager.swift
//  WatchOut
//
//  Created by 어재선 on 9/4/25.
//

import Foundation
import UserNotifications

// 알림을 관리하는 클래스 (싱글톤으로 구현)
class NotificationManager {
    
    // NotificationManager의 유일한 인스턴스에 접근하기 위한 정적 프로퍼티
    static let instance = NotificationManager()
    private init() {} // 다른 곳에서 인스턴스를 생성하는 것을 방지
    
    // 1. 알림 권한 요청 함수
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print("SUCCESS: Notification permission granted.")
            }
        }
    }
    
    // 2. 알림 예약(전송) 함수
    func scheduleNotification(title: String, subtitle: String, secondsLater: TimeInterval) {
        
        // 알림 콘텐츠 설정
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default
        content.badge = 1 // 앱 아이콘에 표시될 숫자
        
        // 알림 트리거 설정 (언제 알림을 보낼지)
        // 여기서는 지정된 시간(초) 후에 알림이 발생하도록 설정
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsLater, repeats: false)
        
        // 알림 요청 생성
        let request = UNNotificationRequest(
            identifier: UUID().uuidString, // 각 알림을 식별하기 위한 고유 ID
            content: content,
            trigger: trigger)
        
        // 시스템에 알림 요청 추가
        UNUserNotificationCenter.current().add(request)
        
        print("Notification scheduled for \(secondsLater) seconds later.")
    }
    
    // 3. 예정된 모든 알림 취소 함수
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All pending notifications cancelled.")
    }
}
