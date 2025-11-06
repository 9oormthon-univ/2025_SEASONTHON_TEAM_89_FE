//
//  KeyboardView.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/3/25.
//
import SwiftUI

struct KeyboardView: View {
    @ObservedObject var controller: KeyboardViewController
    
   
    @ObservedObject private var webSocketService = WebSocketService.shared
    
    @State private var webSocketURL = "wss://wiheome.ajb.kr/api/ws/fraud/"
    @State var status = "정상"
    @State var count = 0
    @State var oldText : String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            
            bannerView()
            
            
            ForEach(controller.keyLayout, id: \.self) { row in
                HStack(spacing: 7) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            controller.handleKeyPress(key)
                            let currentText = controller.textDocumentProxy.documentContextBeforeInput ?? ""
                            
                            webSocketService.checkFraudMessage(currentText)
                        }) {
                            keyView(for: key)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .onAppear {
           
            webSocketService.connect(urlString: webSocketURL)
            status = "정상"
        }
        .onDisappear {
          
            webSocketService.disconnect()
            status = "정상"
        }
        
        .onChange(of: webSocketService.fraudResult?.riskLevel) {
            if let newRiskLevel = webSocketService.fraudResult?.riskLevel {
                print("\(SharedUserDefaults.isTutorial)")
                status = newRiskLevel
                
                if status == "주의" {
                    if SharedUserDefaults.isWarningHaptic {
                        Haptic.notification(type: .warning)
                        
                    }
                    if SharedUserDefaults.isTutorial == false {
                        SharedUserDefaults.riskLevel2Count += 1
                    }
                    
                } else if status == "위험" {
                    count += 1
                    if SharedUserDefaults.isTutorial  == false {
                        SharedUserDefaults.riskLevel3Count += 1
                    }
                    if count % 3 == 0 {
                        if SharedUserDefaults.isDangerNotification {
                            NotificationManager.instance.scheduleNotification(title: "위험한 문장이 반복 감지되었어요", subtitle: "필요하다면 즉시 신고를 도와드릴 수 있어요.", secondsLater: 1)
                        }
                    }
                    
                    if SharedUserDefaults.isDangerHaptic {
                        Haptic.notification(type: .error)
                    }
                }
            }
            
        }
        .padding(3)
        .background(Color(.systemGray4).ignoresSafeArea())
    }
    
// MARK: - BannerView
    @ViewBuilder
    private func bannerView() -> some View {
        let isTutorial = SharedUserDefaults.isTutorial
        HStack(spacing: 12) {
            
            if webSocketService.isConnected {
                Image("keyboardicon")
                    .foregroundStyle(.main)
            } else {
                Image("keyboardicon")
                    .foregroundStyle(.gray400)
            }
            
            
            Spacer()

            if status == "주의" {
                if isTutorial {
                    
                    Image("risklevel2")
                        .resizable()
                        .scaledToFit()
                }
                Image("status1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundStyle(Color("RiskColor\(SharedUserDefaults.riskLevel2Color)"))
            } else if status == "위험" {
                if isTutorial {
                    Image("risklevel3")
                        .resizable()
                        .scaledToFit()
                }
                Image("status2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundStyle(Color("RiskColor\(SharedUserDefaults.riskLevel3Color)"))
            } else {
                Image("circle01")
            }

        }
        .padding(.horizontal, 15)
        .frame(height: 40)
        .cornerRadius(8)
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
        .shadow(color: .black.opacity(0.35), radius: 0.5, x: 0, y: 1)
    }
    // MARK: - keyBackgroundColor
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

