//
//  VerifyResponse.swift
//  WatchOut
//
//  Created by 어재선 on 11/9/25.
//

import Foundation

struct VerifyResponse: Codable {
    let isValid: Bool
    
    enum CodingKeys: String, CodingKey {
        case isValid = "is_valid"
    }
}
