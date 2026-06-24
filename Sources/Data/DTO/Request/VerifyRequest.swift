//
//  VerifyRequest.swift
//  WatchOut
//
//  Created by 어재선 on 11/9/25.
//

import Foundation

public struct VerifyRequest: Codable{
    public let joinCode: String
    public init(joinCode: String) {
        self.joinCode = joinCode
    }
        
    public enum CodingKeys: String, CodingKey{
        case joinCode = "join_code"
    }
}
