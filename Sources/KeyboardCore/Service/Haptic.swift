//
//  Haptic.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/6/25.
//
import Foundation
import UIKit

public class Haptic {
    public static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    public static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
