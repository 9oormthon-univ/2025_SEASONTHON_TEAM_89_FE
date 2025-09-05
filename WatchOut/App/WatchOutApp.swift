//
//  WatchOutApp.swift
//  WatchOut
//
//  Created by 어재선 on 9/2/25.
//

import SwiftUI

@main
struct WatchOutApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ExperienceView()
        }
    }
}
