//
//  ChatResponse.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/6/25.
//

import Foundation

struct ChatResponse: Codable {
    let result: ChatResult
}

// "result" 객체 내부의 데이터 모델
struct ChatResult: Codable {
    let riskLevel: String
    let confidence: Double
    let detectedPatterns: [String]
    let explanation: String
    let recommendedAction: String
}
