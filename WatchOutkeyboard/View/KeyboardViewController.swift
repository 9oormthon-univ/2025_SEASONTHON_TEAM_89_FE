//
//  KeyboardViewController.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/3/25.
//
import UIKit
import SwiftUI
import Combine

class KeyboardViewController: UIInputViewController, ObservableObject {

    // MARK: - Types
    enum KeyboardMode {
        case korean, english, symbols, moreSymbols
    }

    // MARK: - Properties
    private let hangulEngine = HangulEngine()
//    let typingDebounceManager = TypingDebounceManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isShifted = false
    @Published var keyboardMode: KeyboardMode = .korean

    // MARK: - Computed Properties
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
        setupUI()
//        setupBindings()
    }
    
    private func setupUI() {
        let keyboardView = KeyboardView(controller: self)
        let hostingController = UIHostingController(rootView: keyboardView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
//    private func setupBindings() {
//        typingDebounceManager.objectWillChange
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                self?.objectWillChange.send()
//            }
//            .store(in: &cancellables)
//    }

    // MARK: - Text Input Management
    override func textWillChange(_ textInput: UITextInput?) {
        finalizeHangulInput()
    }
    
    override func textDidChange(_ textInput: (any UITextInput)?) {
        // 텍스트가 변경된 후, 텍스트 필드가 완전히 비었는지 확인합니다.
           // (예: 메시지 전송 후)
           let proxy = self.textDocumentProxy
           if proxy.documentContextBeforeInput?.isEmpty ?? true &&
              proxy.documentContextAfterInput?.isEmpty ?? true {
               
               // 텍스트 필드가 비었다면, 한글 엔진의 상태를 깨끗하게 리셋합니다.
               hangulEngine.reset()
           }
    }
    
    private func finalizeHangulInput() {
        let output = hangulEngine.finalize()
        if !output.textToInsert.isEmpty || output.charactersToDelete > 0 {
            commitText(output: output)
        } else {
            hangulEngine.reset()
        }
    }

    // MARK: - Key Handling
    func handleKeyPress(_ key: KeyType) {
        // UIDevice.current.playInputClick()  // 필요시 주석 해제
        
        switch key {
        case .character(let char):
            handleCharacterKey(char)
            
        case .shift:
            isShifted.toggle()
            
        case .backspace:
            handleBackspaceKey()
            
        case .space:
            handleSpaceKey()
            
        case .enter:
            handleEnterKey()

        case .modeChange:
            handleModeChangeKey()
            
        case .switchToSymbols:
            switchToMode(.symbols)
            
        case .switchToAlphabetic:
            switchToMode(.korean)
            
        case .switchToMoreSymbols:
            switchToMode(.moreSymbols)
        }
    }
    
    private func handleCharacterKey(_ char: Character) {
        if keyboardMode == .korean {
            let output = hangulEngine.process(jamo: char)
            commitText(output: output)
        } else {
            textDocumentProxy.insertText(String(char))
        }
        
        // 영문/한글 모드에서 Shift 자동 해제
        if isShifted && (keyboardMode == .korean || keyboardMode == .english) {
            isShifted = false
        }
    }
    
    private func handleBackspaceKey() {
        if keyboardMode == .korean {
            let output = hangulEngine.deleteBackward()
            commitText(output: output)
        } else {
            textDocumentProxy.deleteBackward()
        }
    }
    
    private func handleSpaceKey() {
        finalizeHangulInput()
        textDocumentProxy.insertText(" ")
    }
    
    private func handleEnterKey() {
        finalizeHangulInput()
        textDocumentProxy.insertText("\n")
    }
    
    private func handleModeChangeKey() {
        finalizeHangulInput()
        keyboardMode = (keyboardMode == .korean) ? .english : .korean
        resetShiftAndNotify()
    }
    
    private func switchToMode(_ mode: KeyboardMode) {
        finalizeHangulInput()
        keyboardMode = mode
        resetShiftAndNotify()
    }
    
    private func resetShiftAndNotify() {
        isShifted = false
        objectWillChange.send()
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

// MARK: - Layouts
private extension KeyboardViewController {
    var koreanLayout: [[KeyType]] {
        [
            [.character("ㅂ"), .character("ㅈ"), .character("ㄷ"), .character("ㄱ"), .character("ㅅ"), .character("ㅛ"), .character("ㅕ"), .character("ㅑ"), .character("ㅐ"), .character("ㅔ")],
            [.character("ㅁ"), .character("ㄴ"), .character("ㅇ"), .character("ㄹ"), .character("ㅎ"), .character("ㅗ"), .character("ㅓ"), .character("ㅏ"), .character("ㅣ")],
            [.shift, .character("ㅋ"), .character("ㅌ"), .character("ㅊ"), .character("ㅍ"), .character("ㅠ"), .character("ㅜ"), .character("ㅡ"), .backspace],
            [.switchToSymbols, .modeChange, .space, .enter]
        ]
    }
    
    var koreanShiftedLayout: [[KeyType]] {
        [
            [.character("ㅃ"), .character("ㅉ"), .character("ㄸ"), .character("ㄲ"), .character("ㅆ"), .character("ㅛ"), .character("ㅕ"), .character("ㅑ"), .character("ㅒ"), .character("ㅖ")],
            [.character("ㅁ"), .character("ㄴ"), .character("ㅇ"), .character("ㄹ"), .character("ㅎ"), .character("ㅗ"), .character("ㅓ"), .character("ㅏ"), .character("ㅣ")],
            [.shift, .character("ㅋ"), .character("ㅌ"), .character("ㅊ"), .character("ㅍ"), .character("ㅠ"), .character("ㅜ"), .character("ㅡ"), .backspace],
            [.switchToSymbols, .modeChange, .space, .enter]
        ]
    }
    
    var englishLayout: [[KeyType]] {
        [
            [.character("q"), .character("w"), .character("e"), .character("r"), .character("t"), .character("y"), .character("u"), .character("i"), .character("o"), .character("p")],
            [.character("a"), .character("s"), .character("d"), .character("f"), .character("g"), .character("h"), .character("j"), .character("k"), .character("l")],
            [.shift, .character("z"), .character("x"), .character("c"), .character("v"), .character("b"), .character("n"), .character("m"), .backspace],
            [.switchToSymbols, .modeChange, .space, .enter]
        ]
    }
    
    var englishShiftedLayout: [[KeyType]] {
        [
            [.character("Q"), .character("W"), .character("E"), .character("R"), .character("T"), .character("Y"), .character("U"), .character("I"), .character("O"), .character("P")],
            [.character("A"), .character("S"), .character("D"), .character("F"), .character("G"), .character("H"), .character("J"), .character("K"), .character("L")],
            [.shift, .character("Z"), .character("X"), .character("C"), .character("V"), .character("B"), .character("N"), .character("M"), .backspace],
            [.switchToSymbols, .modeChange, .space, .enter]
        ]
    }

    var symbolsLayout: [[KeyType]] {
        [
            [.character("1"), .character("2"), .character("3"), .character("4"), .character("5"), .character("6"), .character("7"), .character("8"), .character("9"), .character("0")],
            [.character("-"), .character("/"), .character(":"), .character(";"), .character("("), .character(")"), .character("$"), .character("&"), .character("@"), .character("\"")],
            [.shift, .character("."), .character(","), .character("?"), .character("!"), .character("'"), .backspace],
            [.switchToMoreSymbols, .modeChange, .space, .enter]
        ]
    }
    
    var moreSymbolsLayout: [[KeyType]] {
        [
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

