//
//  Hangul.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/3/25.
//

import Foundation

// MARK: - 한글 유니코드 상수
private enum HangulUnicode {
    static let base: UInt32 = 0xAC00 // "가"
    static let choCount: Int = 19
    static let jungCount: Int = 21
    static let jongCount: Int = 28 // 종성 없음(0) 포함
}

// MARK: - 자모 배열 및 맵
private let choArr: [Character] = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
private let jungArr: [Character] = ["ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"]
private let jongArr: [Character] = [" ", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"] // index 0 = 종성 없음

private let choMap: [Character: Int] = Dictionary(uniqueKeysWithValues: choArr.enumerated().map { ($1, $0) })
private let jungMap: [Character: Int] = Dictionary(uniqueKeysWithValues: jungArr.enumerated().map { ($1, $0) })
private let jongMap: [Character: Int] = Dictionary(uniqueKeysWithValues: jongArr.enumerated().map { ($1, $0) })

private let jamosIntoJamo: [[Character]: Character] = [
    ["ㅗ", "ㅏ"]: "ㅘ", ["ㅗ", "ㅐ"]: "ㅙ", ["ㅗ", "ㅣ"]: "ㅚ", ["ㅜ", "ㅓ"]: "ㅝ", ["ㅜ", "ㅔ"]: "ㅞ", ["ㅜ", "ㅣ"]: "ㅟ",
    ["ㅡ", "ㅣ"]: "ㅢ", ["ㄱ", "ㅅ"]: "ㄳ", ["ㄴ", "ㅈ"]: "ㄵ", ["ㄴ", "ㅎ"]: "ㄶ", ["ㄹ", "ㄱ"]: "ㄺ", ["ㄹ", "ㅁ"]: "ㄻ",
    ["ㄹ", "ㅂ"]: "ㄼ", ["ㄹ", "ㅅ"]: "ㄽ", ["ㄹ", "ㅌ"]: "ㄾ", ["ㄹ", "ㅍ"]: "ㄿ", ["ㄹ", "ㅎ"]: "ㅀ", ["ㅂ", "ㅅ"]: "ㅄ"
]
private let jamoIntoJamos: [Character: [Character]] = Dictionary(uniqueKeysWithValues: jamosIntoJamo.map { ($1, $0) })

// MARK: - Hangul 구조체
struct Hangul {
    var cho: Character?
    var jung: Character?
    var jong: Character?

    init?(_ character: Character) {
        switch character {
        case "ㄱ"..."ㅎ":
            guard choMap[character] != nil else { return nil }
            self.cho = character
        case "ㅏ"..."ㅣ":
            guard jungMap[character] != nil else { return nil }
            self.jung = character
        case "가"..."힣":
            let offset = Int(character.unicodeScalars.first!.value - HangulUnicode.base)
            let jongIdx = offset % HangulUnicode.jongCount
            let jungIdx = (offset / HangulUnicode.jongCount) % HangulUnicode.jungCount
            let choIdx = offset / (HangulUnicode.jongCount * HangulUnicode.jungCount)

            self.cho = choArr[choIdx]
            self.jung = jungArr[jungIdx]
            self.jong = jongIdx == 0 ? nil : jongArr[jongIdx]
        default:
            return nil
        }
    }
    
    init?(cho: Character? = nil, jung: Character? = nil, jong: Character? = nil) {
        self.cho = cho
        self.jung = jung
        self.jong = jong
    }

    var character: Character? {
        if let cho = self.cho, let jung = self.jung { // 초성+중성 (종성 포함)
            guard let choIdx = choMap[cho], let jungIdx = jungMap[jung] else { return nil }
            
            let jongIdx = (jong != nil) ? jongMap[jong!] ?? 0 : 0
            
            let scalarValue = HangulUnicode.base + UInt32(choIdx * HangulUnicode.jungCount * HangulUnicode.jongCount) + UInt32(jungIdx * HangulUnicode.jongCount) + UInt32(jongIdx)
            return Character(UnicodeScalar(scalarValue)!)
            
        } else if let cho = self.cho { // 단독 자음
            return cho
        } else if let jung = self.jung { // 단독 모음
            return jung
        }
        return nil
    }

    static func combineHanguls(_ hangul1: Hangul, _ hangul2: Hangul) -> (combined: Hangul?, leftover: Hangul?) {
        // CASE 1: 초성 + 중성
        if let cho1 = hangul1.cho, hangul1.jung == nil, hangul1.jong == nil,
           let jung2 = hangul2.jung, hangul2.cho == nil, hangul2.jong == nil {
            return (Hangul(cho: cho1, jung: jung2), nil)
        }
        // CASE 2: 중성 + 중성
        if let jung1 = hangul1.jung, hangul1.cho == nil,
           let jung2 = hangul2.jung, hangul2.cho == nil {
            if let combinedJung = jamosIntoJamo[[jung1, jung2]] {
                return (Hangul(jung: combinedJung), nil)
            }
        }
        // CASE 3: (초성+중성) + 종성
        if let cho1 = hangul1.cho, let jung1 = hangul1.jung, hangul1.jong == nil,
           let cho2 = hangul2.cho, hangul2.jung == nil, jongMap[cho2] != nil {
            return (Hangul(cho: cho1, jung: jung1, jong: cho2), nil)
        }
        // CASE 4: (초성+중성+종성) + 중성
        if let cho1 = hangul1.cho, let jung1 = hangul1.jung, let jong1 = hangul1.jong,
           let jung2 = hangul2.jung, hangul2.cho == nil {
            if let decomposedJong = jamoIntoJamos[jong1] { // 복합 종성 분리
                return (Hangul(cho: cho1, jung: jung1, jong: decomposedJong.first!), Hangul(cho: decomposedJong.last!, jung: jung2))
            } else { // 단일 종성 분리
                return (Hangul(cho: cho1, jung: jung1, jong: nil), Hangul(cho: jong1, jung: jung2))
            }
        }
        // CASE 5: (초성+중성+종성) + 종성
        if let cho1 = hangul1.cho, let jung1 = hangul1.jung, let jong1 = hangul1.jong,
           let cho2 = hangul2.cho, hangul2.jung == nil, jongMap[cho2] != nil {
            if let combinedJong = jamosIntoJamo[[jong1, cho2]] {
                return (Hangul(cho: cho1, jung: jung1, jong: combinedJong), nil)
            }
        }
        // CASE 6: (초성+중성) + 중성 (복합 모음)
        if let cho1 = hangul1.cho, let jung1 = hangul1.jung, hangul1.jong == nil,
           let jung2 = hangul2.jung, hangul2.cho == nil {
            if let combinedJung = jamosIntoJamo[[jung1, jung2]] {
                return (Hangul(cho: cho1, jung: combinedJung), nil)
            }
        }
        return (nil, nil)
    }

    static func deleteBackward(_ char: Character) -> Character? {
        guard let hangul = Hangul(char) else { return nil }

        if let cho = hangul.cho, let jung = hangul.jung, let jong = hangul.jong {
            if let jongs = jamoIntoJamos[jong] {
                return Hangul(cho: cho, jung: jung, jong: jongs.first!)?.character
            } else {
                return Hangul(cho: cho, jung: jung)?.character
            }
        } else if let cho = hangul.cho, let jung = hangul.jung {
            if let jungs = jamoIntoJamos[jung] {
                return Hangul(cho: cho, jung: jungs.first!)?.character
            } else {
                return Hangul(cho: cho)?.character
            }
        } else if hangul.cho != nil {
            return nil
        } else if let jung = hangul.jung {
            if let jungs = jamoIntoJamos[jung] {
                return Hangul(jung: jungs.first!)?.character
            } else {
                return nil
            }
        }
        return nil
    }
}

