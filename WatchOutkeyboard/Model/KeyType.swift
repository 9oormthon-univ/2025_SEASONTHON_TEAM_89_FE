//
//  KeyType.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/3/25.
//

import Foundation

enum KeyType: Hashable {
    case character(Character)
    case shift
    case backspace
    case space
    case enter
    case modeChange 
    case switchToSymbols
    case switchToAlphabetic
    case switchToMoreSymbols
    
    
    var displayText: String {
        switch self {
        case .character(let char):
            return String(char)
        case .shift:
            return "⇧"
        case .backspace:
            return "⌫"
        case .space:
            return "space"
        case .enter:
            return "enter"
        case .modeChange:
            return "한/영"
        case .switchToSymbols:
            return "123"
        case .switchToAlphabetic:
            return "ABC"
        case .switchToMoreSymbols:
            return "#+="
        }
    }
}

