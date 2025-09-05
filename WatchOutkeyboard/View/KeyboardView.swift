//
//  KeyboardView.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/3/25.
//
import SwiftUI

struct KeyboardView: View {
    @ObservedObject var controller: KeyboardViewController

    var body: some View {
        VStack(spacing: 8) {
            // 1. 상단 배너 뷰 추가
            bannerView()
            
            // 2. 기존 키보드 키 레이아웃
            ForEach(controller.keyLayout, id: \.self) { row in
                HStack(spacing: 7) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            controller.handleKeyPress(key)
                            let currentText = controller.textDocumentProxy.documentContextBeforeInput ?? ""
                                                       
                            // 3. 디바운스 관리자의 타이머를 리셋
                            controller.debounceManager.resetTimer(for: currentText)
                            
                        }) {
                            keyView(for: key) // 각 키의 UI를 생성하는 헬퍼 뷰
                        }
                        .buttonStyle(.plain) // 버튼의 기본 스타일 제거
                    }
                }
            }
        }
        .padding(3)
        .background(Color(.systemGray4).ignoresSafeArea())
    }

    /// 상단 배너 UI를 구성하는 뷰입니다.
    @ViewBuilder
    private func bannerView() -> some View {
        HStack(spacing: 12) {
            // 예시 로고
          Image("keyboardicon")
                
            
            Spacer()
//            Button("알림 권한 요청하기  Permission 🙏") {
//                NotificationManager.instance.requestAuthorization()
//            }
//            .buttonStyle(.borderedProminent)
//            .foregroundStyle(SharedUserDefaults.color(forName: SharedUserDefaults.warningColorLevel1))
//            // 5초 후 알림 예약 버튼
//            Button("5초 후 알림 예약하기 Schedule ⏰") {
//                NotificationManager.instance.scheduleNotification(
//                    title: "위험한 문장이 반복 감지되었어요",
//                    subtitle: "필요하다면 즉시 신고를 도와드릴 수 있어요.",
//                    secondsLater: 1
//                )
//            }
//            .buttonStyle(.bordered)
            Image("circle01")
                
        }
        .padding(.horizontal, 15)
        .frame(height: 40)

        .cornerRadius(8)
    }

    /// 각 키의 타입에 따라 다른 UI를 그려주는 뷰 빌더입니다.
    @ViewBuilder
    private func keyView(for key: KeyType) -> some View {
        Group {
            switch key {
            case .shift:
                Image(controller.isShifted ? "shiftOn" : "shiftOff")
                    .scaledToFit()
                    .frame(width: 20)
                    
//                    .foregroundColor(controller.isShifted ? Color(.systemBlue) : .primary)
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
        .shadow(color: .black.opacity(0.35), radius: 0.5, x: 0, y: 1)
    }

    /// 키의 배경색을 결정하는 헬퍼 함수입니다.
    private func keyBackgroundColor(for key: KeyType) -> Color {
        switch key {
        case .character:
            return Color(.systemBackground)
        case .space:
            return Color(.systemBackground)
        case .enter:
            return Color("MainColor")
        case .shift:
            if controller.isShifted {
                return Color("MainColor")
            } else {
                return Color(.systemBackground)
            }
        default:
            return Color(.systemBackground)
        }
    }
    
    /// 키의 너비를 결정하는 헬퍼 함수입니다.
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

