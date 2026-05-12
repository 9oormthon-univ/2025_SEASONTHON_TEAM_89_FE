//
//  VerifyResponse.swift
//  WatchOut
//
//  Created by 어재선 on 11/9/25.
//

import Foundation

public struct VerifyResponse: Codable {
    public let isValid: Bool
    
    public init(isValid: Bool) {
        self.isValid = isValid
    }
    
    public enum CodingKeys: String, CodingKey {
        case isValid = "is_valid"
    }
}
