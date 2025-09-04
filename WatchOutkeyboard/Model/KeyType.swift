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
    case modeChange // 한/영 전환
    case switchToSymbols
    case switchToAlphabetic
    case switchToMoreSymbols
    
    // 키보드 UI에 표시될 텍스트
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

