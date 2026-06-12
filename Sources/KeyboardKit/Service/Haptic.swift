//
//  Haptic.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/6/25.
//
import Foundation
import UIKit

public class Haptic {
    // 키 입력 전용 — 매번 생성하면 첫 진동이 지연되므로 재사용 + prepare()로 즉각 반응
    private static let keyPressGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        return generator
    }()

    /// iOS 시스템 키보드에 근접한 짧고 단단한 틱
    public static func keyPress() {
        keyPressGenerator.impactOccurred(intensity: 0.65)
        keyPressGenerator.prepare()
    }

    public static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    public static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
