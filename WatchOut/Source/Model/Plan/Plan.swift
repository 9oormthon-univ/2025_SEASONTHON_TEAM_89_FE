//
//  Plan.swift
//  WatchOut
//
//  Created by 어재선 on 11/8/25.
//

import Foundation


enum PlanType: String, CaseIterable {
    case individual = "개인"
    case family = "패밀리"
    
}

enum Individual: String, CaseIterable {
    case basic = "Basic"
    case plus = "Plus"
}

enum Family: String, CaseIterable {
    case familyA = "Family A"
    case familyB = "Family B"
}
