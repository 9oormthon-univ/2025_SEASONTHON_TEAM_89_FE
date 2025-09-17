//
//  WatchOutApp.swift
//  WatchOut
//
//  Created by 어재선 on 9/2/25.
//

import SwiftUI
import KakaoSDKCommon

@main
struct WatchOutApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
            // Kakao SDK 초기화
            let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String
            KakaoSDK.initSDK(appKey: kakaoAppKey ?? "")
        }
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
