//
//  Plan.swift
//  WatchOut
//
//  Created by 어재선 on 11/8/25.
//

import Foundation


public enum PlanType: String, CaseIterable {
    case individual = "개인"
    case family = "패밀리"
    
}

public enum Individual: String, CaseIterable {
    case basic = "Basic"
    case plus = "Plus"
}

public enum Family: String, CaseIterable {
    case familyA = "Family A"
    case familyB = "Family B"
}
