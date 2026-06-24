//
//  KeyboardViewController.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/3/25.
//
import UIKit
import SwiftUI
import KeyboardKit

class KeyboardViewController: UIInputViewController, ObservableObject {

    // MARK: - Properties
    private let hangulEngine = HangulEngine()
    
    @Published var isShifted = false
    @Published var keyboardMode: KeyboardMode = .korean

    // MARK: - Computed Properties
    var keyLayout: [[KeyType]] {
        KeyboardLayoutProvider.layout(mode: keyboardMode, isShifted: isShifted)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

    // MARK: - Text Input Management
    override func textWillChange(_ textInput: UITextInput?) {
        finalizeHangulInput()
    }
    
    override func textDidChange(_ textInput: (any UITextInput)?) {
      
           let proxy = self.textDocumentProxy
           if proxy.documentContextBeforeInput?.isEmpty ?? true &&
              proxy.documentContextAfterInput?.isEmpty ?? true {
               
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

    // MARK: - Long Press (쌍자음)
    private static let shiftedJamo: [Character: Character] = [
        "ㄱ": "ㄲ", "ㄷ": "ㄸ", "ㅂ": "ㅃ", "ㅈ": "ㅉ", "ㅅ": "ㅆ"
    ]

    func variant(for key: KeyType) -> Character? {
        guard case .character(let char) = key else { return nil }
        switch keyboardMode {
        case .korean:
            return Self.shiftedJamo[char]
        case .english:
            guard char.isLowercase else { return nil }
            return Character(char.uppercased())
        default:
            return nil
        }
    }

    func handleLongPress(_ key: KeyType) {
        guard let shifted = variant(for: key) else {
            handleKeyPress(key)
            return
        }
        handleCharacterKey(shifted)
    }

    // MARK: - Cursor Movement (스페이스 트랙패드)
    func beginCursorMode() {
        finalizeHangulInput()
    }

    func moveCursor(by offset: Int) {
        textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
    }

    // MARK: - Key Handling
    func handleKeyPress(_ key: KeyType) {
        
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

extension UITextDocumentProxy {
    func deleteBackward(times: Int) {
        for _ in 0..<times {
            deleteBackward()
        }
    }
}

