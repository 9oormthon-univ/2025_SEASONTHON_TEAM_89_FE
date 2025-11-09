//
//  VerifyRequest.swift
//  WatchOut
//
//  Created by 어재선 on 11/9/25.
//

import Foundation

struct VerifyRequest: Codable{
    let joinCode: String
    
    enum CodingKeys: String, CodingKey{
        case joinCode = "join_code"
    }
}
