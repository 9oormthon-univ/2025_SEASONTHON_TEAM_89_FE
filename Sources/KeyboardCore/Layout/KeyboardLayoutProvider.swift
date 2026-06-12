//
//  KeyboardLayoutProvider.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 6/12/26.
//

import Foundation

public enum KeyboardLayoutProvider {

    public static func layout(mode: KeyboardMode, isShifted: Bool) -> [[KeyType]] {
        switch mode {
        case .korean:
            return isShifted ? koreanShifted : korean
        case .english:
            return isShifted ? englishShifted : english
        case .symbols:
            return symbols
        case .moreSymbols:
            return moreSymbols
        }
    }

    private static let korean: [[KeyType]] = [
        [.character("ㅂ"), .character("ㅈ"), .character("ㄷ"), .character("ㄱ"), .character("ㅅ"), .character("ㅛ"), .character("ㅕ"), .character("ㅑ"), .character("ㅐ"), .character("ㅔ")],
        [.character("ㅁ"), .character("ㄴ"), .character("ㅇ"), .character("ㄹ"), .character("ㅎ"), .character("ㅗ"), .character("ㅓ"), .character("ㅏ"), .character("ㅣ")],
        [.shift, .character("ㅋ"), .character("ㅌ"), .character("ㅊ"), .character("ㅍ"), .character("ㅠ"), .character("ㅜ"), .character("ㅡ"), .backspace],
        [.switchToSymbols, .modeChange, .space, .enter]
    ]

    private static let koreanShifted: [[KeyType]] = [
        [.character("ㅃ"), .character("ㅉ"), .character("ㄸ"), .character("ㄲ"), .character("ㅆ"), .character("ㅛ"), .character("ㅕ"), .character("ㅑ"), .character("ㅒ"), .character("ㅖ")],
        [.character("ㅁ"), .character("ㄴ"), .character("ㅇ"), .character("ㄹ"), .character("ㅎ"), .character("ㅗ"), .character("ㅓ"), .character("ㅏ"), .character("ㅣ")],
        [.shift, .character("ㅋ"), .character("ㅌ"), .character("ㅊ"), .character("ㅍ"), .character("ㅠ"), .character("ㅜ"), .character("ㅡ"), .backspace],
        [.switchToSymbols, .modeChange, .space, .enter]
    ]

    private static let english: [[KeyType]] = [
        [.character("q"), .character("w"), .character("e"), .character("r"), .character("t"), .character("y"), .character("u"), .character("i"), .character("o"), .character("p")],
        [.character("a"), .character("s"), .character("d"), .character("f"), .character("g"), .character("h"), .character("j"), .character("k"), .character("l")],
        [.shift, .character("z"), .character("x"), .character("c"), .character("v"), .character("b"), .character("n"), .character("m"), .backspace],
        [.switchToSymbols, .modeChange, .space, .enter]
    ]

    private static let englishShifted: [[KeyType]] = [
        [.character("Q"), .character("W"), .character("E"), .character("R"), .character("T"), .character("Y"), .character("U"), .character("I"), .character("O"), .character("P")],
        [.character("A"), .character("S"), .character("D"), .character("F"), .character("G"), .character("H"), .character("J"), .character("K"), .character("L")],
        [.shift, .character("Z"), .character("X"), .character("C"), .character("V"), .character("B"), .character("N"), .character("M"), .backspace],
        [.switchToSymbols, .modeChange, .space, .enter]
    ]

    private static let symbols: [[KeyType]] = [
        [.character("1"), .character("2"), .character("3"), .character("4"), .character("5"), .character("6"), .character("7"), .character("8"), .character("9"), .character("0")],
        [.character("-"), .character("/"), .character(":"), .character(";"), .character("("), .character(")"), .character("$"), .character("&"), .character("@"), .character("\"")],
        [.shift, .character("."), .character(","), .character("?"), .character("!"), .character("'"), .backspace],
        [.switchToMoreSymbols, .modeChange, .space, .enter]
    ]

    private static let moreSymbols: [[KeyType]] = [
        [.character("["), .character("]"), .character("{"), .character("}"), .character("#"), .character("%"), .character("^"), .character("*"), .character("+"), .character("=")],
        [.character("_"), .character("\\"), .character("|"), .character("~"), .character("<"), .character(">"), .character("€"), .character("£"), .character("¥"), .character("•")],
        [.shift, .character("."), .character(","), .character("?"), .character("!"), .character("'"), .backspace],
        [.switchToSymbols, .modeChange, .space, .enter]
    ]
}
