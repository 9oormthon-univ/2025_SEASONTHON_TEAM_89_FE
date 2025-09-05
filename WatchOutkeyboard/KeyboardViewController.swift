//
//  KeyboardViewController.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/3/25.
//
import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController, ObservableObject {

    // MARK: - Properties
    private var hangulEngine = HangulEngine()
    let debounceManager = TypingDebounceManager()
    @Published var isShifted = false
    @Published var keyboardMode: KeyboardMode = .korean
    
    
    // 키보드 모드에 특수문자 케이스 추가
    enum KeyboardMode {
        case korean, english, symbols, moreSymbols
    }

    // 현재 모드에 맞는 키보드 레이아웃을 반환
    var keyLayout: [[KeyType]] {
        switch keyboardMode {
        case .korean:
            return isShifted ? koreanShiftedLayout : koreanLayout
        case .english:
            return isShifted ? englishShiftedLayout : englishLayout
        case .symbols:
            return symbolsLayout
        case .moreSymbols:
            return moreSymbolsLayout
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardView = KeyboardView(controller: self)
        let hostingController = UIHostingController(rootView: keyboardView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        let output = hangulEngine.finalize()
        if !output.textToInsert.isEmpty || output.charactersToDelete > 0 {
            commitText(output: output)
        } else {
            hangulEngine.reset()
        }
    }

    // MARK: - Key Handling
    func handleKeyPress(_ key: KeyType) {
//        UIDevice.current.playInputClick() // 키 클릭음 재생
        
        switch key {
        case .character(let char):
            if keyboardMode == .korean {
                let output = hangulEngine.process(jamo: char)
                commitText(output: output)
            } else { // 영어 또는 특수문자 모드
                textDocumentProxy.insertText(String(char))
            }
            if isShifted && (keyboardMode == .korean || keyboardMode == .english) {
                isShifted = false
            }
            
        case .shift:
            isShifted.toggle()
            
        case .backspace:
            if keyboardMode == .korean {
                let output = hangulEngine.deleteBackward()
                commitText(output: output)
            } else {
                textDocumentProxy.deleteBackward()
            }
            
        case .space:
            let output = hangulEngine.finalize()
            commitText(output: output)
            textDocumentProxy.insertText(" ")
            
        case .enter:
            let output = hangulEngine.finalize()
            commitText(output: output)
            textDocumentProxy.insertText("\n")

        case .modeChange:
            let output = hangulEngine.finalize()
            commitText(output: output)
            keyboardMode = (keyboardMode == .korean) ? .english : .korean
            isShifted = false
            objectWillChange.send()
            
        // --- 특수문자 키 처리 로직 ---
        case .switchToSymbols:
            let output = hangulEngine.finalize()
            commitText(output: output)
            keyboardMode = .symbols
            isShifted = false
            objectWillChange.send()
            
        case .switchToAlphabetic:
            keyboardMode = .korean // 기본 문자 모드를 한글로 설정
            isShifted = false
            objectWillChange.send()
            
        case .switchToMoreSymbols:
            keyboardMode = .moreSymbols
            isShifted = false
            objectWillChange.send()
        }
    }
    
    private func commitText(output: EngineOutput) {
        if output.charactersToDelete > 0 {
            textDocumentProxy.deleteBackward(times: output.charactersToDelete)
        }
        if !output.textToInsert.isEmpty {
            textDocumentProxy.insertText(output.textToInsert)
        }
    }
}

// MARK: - Layouts & Extension
private extension KeyboardViewController {
    // --- 기존 레이아웃 (하단 키만 수정) ---
    var koreanLayout: [[KeyType]] {
        return [
            [.character("ㅂ"), .character("ㅈ"), .character("ㄷ"), .character("ㄱ"), .character("ㅅ"), .character("ㅛ"), .character("ㅕ"), .character("ㅑ"), .character("ㅐ"), .character("ㅔ")],
            [.character("ㅁ"), .character("ㄴ"), .character("ㅇ"), .character("ㄹ"), .character("ㅎ"), .character("ㅗ"), .character("ㅓ"), .character("ㅏ"), .character("ㅣ")],
            [.shift, .character("ㅋ"), .character("ㅌ"), .character("ㅊ"), .character("ㅍ"), .character("ㅠ"), .character("ㅜ"), .character("ㅡ"), .backspace],
            [.switchToSymbols, .modeChange, .space, .enter]
        ]
    }
    var koreanShiftedLayout: [[KeyType]] {
        return [
            [.character("ㅃ"), .character("ㅉ"), .character("ㄸ"), .character("ㄲ"), .character("ㅆ"), .character("ㅛ"), .character("ㅕ"), .character("ㅑ"), .character("ㅒ"), .character("ㅖ")],
            [.character("ㅁ"), .character("ㄴ"), .character("ㅇ"), .character("ㄹ"), .character("ㅎ"), .character("ㅗ"), .character("ㅓ"), .character("ㅏ"), .character("ㅣ")],
            [.shift, .character("ㅋ"), .character("ㅌ"), .character("ㅊ"), .character("ㅍ"), .character("ㅠ"), .character("ㅜ"), .character("ㅡ"), .backspace],
            [.switchToSymbols, .modeChange, .space, .enter]
        ]
    }
    var englishLayout: [[KeyType]] {
        return [
            [.character("q"), .character("w"), .character("e"), .character("r"), .character("t"), .character("y"), .character("u"), .character("i"), .character("o"), .character("p")],
            [.character("a"), .character("s"), .character("d"), .character("f"), .character("g"), .character("h"), .character("j"), .character("k"), .character("l")],
            [.shift, .character("z"), .character("x"), .character("c"), .character("v"), .character("b"), .character("n"), .character("m"), .backspace],
            [.switchToSymbols, .modeChange, .space, .enter]
        ]
    }
    var englishShiftedLayout: [[KeyType]] {
        return [
            [.character("Q"), .character("W"), .character("E"), .character("R"), .character("T"), .character("Y"), .character("U"), .character("I"), .character("O"), .character("P")],
            [.character("A"), .character("S"), .character("D"), .character("F"), .character("G"), .character("H"), .character("J"), .character("K"), .character("L")],
            [.shift, .character("Z"), .character("X"), .character("C"), .character("V"), .character("B"), .character("N"), .character("M"), .backspace],
            [.switchToSymbols, .modeChange, .space, .enter]
        ]
    }

    // --- 새로 추가된 특수문자 레이아웃 ---
    var symbolsLayout: [[KeyType]] {
        return [
            [.character("1"), .character("2"), .character("3"), .character("4"), .character("5"), .character("6"), .character("7"), .character("8"), .character("9"), .character("0")],
            [.character("-"), .character("/"), .character(":"), .character(";"), .character("("), .character(")"), .character("$"), .character("&"), .character("@"), .character("\"")],
            [.shift, .character("."), .character(","), .character("?"), .character("!"), .character("'"), .backspace],
            [.switchToMoreSymbols ,.modeChange, .space, .enter]
        ]
    }
    
    var moreSymbolsLayout: [[KeyType]] {
        return [
            [.character("["), .character("]"), .character("{"), .character("}"), .character("#"), .character("%"), .character("^"), .character("*"), .character("+"), .character("=")],
            [.character("_"), .character("\\"), .character("|"), .character("~"), .character("<"), .character(">"), .character("€"), .character("£"), .character("¥"), .character("•")],
            [.shift, .character("."), .character(","), .character("?"), .character("!"), .character("'"), .backspace],
            [.switchToSymbols, .modeChange, .space, .enter]
        ]
    }
}

extension UITextDocumentProxy {
    func deleteBackward(times: Int) {
        for _ in 0..<times {
            deleteBackward()
        }
    }
}

