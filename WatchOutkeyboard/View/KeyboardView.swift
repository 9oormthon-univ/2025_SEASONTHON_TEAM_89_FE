//
//  KeyboardView.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/3/25.
//
import SwiftUI
import Platform
import DesignSystem
import KeyboardKit

struct KeyboardView: View {
    @ObservedObject var controller: KeyboardViewController
    
    
    @StateObject private var fraudSession = FraudDetectionSession()

    @State private var webSocketURL = "wss://wiheome.ajb.kr/api/ws/fraud/"

    // 롱프레스 상태 (쌍자음/대문자 팝업, 백스페이스 반복, 스페이스 커서 모드)
    @State private var keyFrames: [KeyType: CGRect] = [:]
    @State private var popupKey: KeyType?
    @State private var pressedKeys: Set<KeyType> = []
    @State private var longPressTasks: [KeyType: Task<Void, Never>] = [:]
    @State private var didRepeatDelete = false
    @State private var spaceCursorMode = false
    @State private var spaceCursorSteps = 0
    @State private var spaceTranslation: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Spacer()
                    .frame(width:1)
                VStack(spacing: 8) {

                    bannerView()


                    ForEach(controller.keyLayout, id: \.self) { row in
                        HStack(spacing: 7) {
                            ForEach(row, id: \.self) { key in
                                keyView(for: key)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8.5)
                                            .fill(.black.opacity(pressedKeys.contains(key) ? 0.12 : 0))
                                    )
                                    .animation(pressedKeys.contains(key) ? nil : .easeOut(duration: 0.15), value: pressedKeys.contains(key))
                                    .contentShape(Rectangle())
                                    .background(GeometryReader { geo in
                                        Color.clear.preference(
                                            key: KeyFramePreferenceKey.self,
                                            value: [key: geo.frame(in: .named("keyboard"))]
                                        )
                                    })
                                    .gesture(keyGesture(for: key))
                            }
                        }
                    }
                }
                .padding(2)
                Spacer()
                    .frame(width:1)

            }

            popupOverlay()
        }
        .coordinateSpace(name: "keyboard")
        .onPreferenceChange(KeyFramePreferenceKey.self) { keyFrames = $0 }
        .onChange(of: controller.keyboardMode) { dismissPopup() }
        .onChange(of: controller.isShifted) { dismissPopup() }
        .onAppear {
            fraudSession.start(urlString: webSocketURL)
        }
        .onDisappear {
            fraudSession.stop()
        }
        .background(Color.keyboardNewBackground.ignoresSafeArea(.keyboard))
    }
    
    // MARK: - BannerView
    @ViewBuilder
    private func bannerView() -> some View {
        HStack(spacing: 12) {
            
            if fraudSession.isConnected {
                Image("keyboardicon")
                    .foregroundStyle(Color.main)
            } else {
                Image("keyboardicon")
                    .foregroundStyle(Color.gray400)
            }
            
            
            Spacer()
            
            switch fraudSession.riskLevel {
            case .safe:
                EmptyView()

            case .caution:
                Image("status1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundStyle(Color.riskColor(SharedUserDefaults.riskLevel2Color))

            case .danger:
                Text("민감한 정보가 포함된 문장입니다")
                    .font(.pHeadline03)
                    .foregroundStyle(Color.risk1Color(SharedUserDefaults.riskLevel3Color))
                Image("status2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundStyle(Color.risk1Color(SharedUserDefaults.riskLevel3Color))
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 40)
        .cornerRadius(8)
    }
    
    // MARK: - Long Press (쌍자음/대문자 팝업, 백스페이스 반복, 스페이스 커서)
    private func keyGesture(for key: KeyType) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if !pressedKeys.contains(key) {
                    pressedKeys.insert(key)
                    Haptic.keyPress()
                    startLongPress(for: key)
                }

                if key == .space {
                    spaceTranslation = value.translation.width
                    if spaceCursorMode {
                        let steps = Int(spaceTranslation / 8)
                        let delta = steps - spaceCursorSteps
                        if delta != 0 {
                            spaceCursorSteps = steps
                            controller.moveCursor(by: delta)
                        }
                    }
                }
            }
            .onEnded { _ in
                pressedKeys.remove(key)
                longPressTasks[key]?.cancel()
                longPressTasks[key] = nil

                switch key {
                case .space where spaceCursorMode:
                    spaceCursorMode = false
                    spaceCursorSteps = 0
                case .backspace where didRepeatDelete:
                    didRepeatDelete = false
                case _ where popupKey == key:
                    popupKey = nil
                    controller.handleLongPress(key)
                default:
                    controller.handleKeyPress(key)
                }

                let currentText = controller.textDocumentProxy.documentContextBeforeInput ?? ""
                fraudSession.check(currentText)
            }
    }

    private func startLongPress(for key: KeyType) {
        longPressTasks[key]?.cancel()

        switch key {
        case .character where controller.variant(for: key) != nil:
            longPressTasks[key] = Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(400))
                guard !Task.isCancelled, pressedKeys.contains(key) else { return }
                popupKey = key
                Haptic.impact(style: .medium)
            }

        case .backspace:
            longPressTasks[key] = Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(400))
                guard !Task.isCancelled, pressedKeys.contains(key) else { return }
                didRepeatDelete = true
                while !Task.isCancelled, pressedKeys.contains(key) {
                    controller.handleKeyPress(.backspace)
                    try? await Task.sleep(for: .milliseconds(100))
                }
            }

        case .space:
            longPressTasks[key] = Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(400))
                guard !Task.isCancelled, pressedKeys.contains(key) else { return }
                controller.beginCursorMode()
                spaceCursorSteps = Int(spaceTranslation / 8)
                spaceCursorMode = true
                Haptic.impact(style: .medium)
            }

        default:
            break
        }
    }

    @ViewBuilder
    private func popupOverlay() -> some View {
        if let popupKey,
           let frame = keyFrames[popupKey],
           let variant = controller.variant(for: popupKey) {
            let popupWidth: CGFloat = 46
            let popupHeight: CGFloat = 44
            let maxX = keyFrames.values.map(\.maxX).max() ?? frame.maxX
            let x = min(max(frame.midX, popupWidth / 2 + 2), maxX - popupWidth / 2)
            let y = max(frame.minY - 26, popupHeight / 2)

            Text(String(variant))
                .font(.system(size: 26, weight: .medium))
                .frame(width: popupWidth, height: popupHeight)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.35), radius: 4, y: 2)
                .position(x: x, y: y)
                .allowsHitTesting(false)
        }
    }

    private func dismissPopup() {
        popupKey = nil
        pressedKeys.removeAll()
        longPressTasks.values.forEach { $0.cancel() }
        longPressTasks.removeAll()
        didRepeatDelete = false
        spaceCursorMode = false
        spaceCursorSteps = 0
    }

    // MARK: - keyView
    @ViewBuilder
    private func keyView(for key: KeyType) -> some View {
        Group {
            switch key {
            case .shift:
                Image(controller.isShifted ? "shiftOn" : "shiftOff")
                    .scaledToFit()
                    .frame(width: 20)
            case .backspace:
                Image("deletebutton")
                
            case .character(let char):
                Text(String(char))
                    .font(.system(size: 22))
            case .enter:
                Image("enterIcon")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 40)
            case .modeChange:
                if controller.keyboardMode == .english {
                    Image("ㄱㄴㄷ")
                    
                } else {
                    Image("ABC")
                    
                }
            case .space:
                Text("")
            case .switchToSymbols:
                Image("onetwo")
            case .switchToMoreSymbols:
                Image("shopplus")
            default: // space, return, modeChange 등
                Text(key.displayText)
                    .font(.keyboardFont)
                    .padding(.horizontal, 5)
            }
        }
        .frame(maxWidth: keyWidth(for: key), minHeight: 42)
        .background(keyBackgroundColor(for: key))
        .foregroundColor(.primary)
        .cornerRadius(8.5)
    }
    // MARK: - keyBackgroundColor
    private func keyBackgroundColor(for key: KeyType) -> Color {
        switch key {
        case .character:
            return Color(.systemBackground)
        case .space:
            return Color(.systemBackground)
        case .enter:
            return Color.main
        case .shift:
            if controller.isShifted {
                return Color.main
            } else {
                return Color(.systemBackground)
            }
        default:
            return Color(.systemBackground)
        }
    }
    
    // MARK: - keyWidth
    private func keyWidth(for key: KeyType) -> CGFloat? {
        switch key {
        case .switchToAlphabetic, .switchToMoreSymbols, .switchToSymbols:
            return 46
        case .modeChange:
            return 46
        case .space:
            return 187
        case .character(let char):
            if char == "." || char == "," || char == "!" || char == "?" || char == "'" {
                return 49
            }
            return 33
            
        case .shift, .backspace:
            return 66

        case .enter:
            return 96

        }
    }
}

// MARK: - KeyFramePreferenceKey
private struct KeyFramePreferenceKey: PreferenceKey {
    static var defaultValue: [KeyType: CGRect] = [:]
    static func reduce(value: inout [KeyType: CGRect], nextValue: () -> [KeyType: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}

