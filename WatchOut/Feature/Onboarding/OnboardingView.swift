//
//  OnboardingView.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import SwiftUI
import UIKit
import Combine

struct OnboardingView: View {
    @State private var isKeyboardEnabled = false
    @State private var isFirstSetting = false
    var body: some View {
        
        ZStack {

            if !isKeyboardEnabled {
                VStack {
                    Rectangle()
                        .fill()
                    OnboardingFristView()
                        .frame(height: 300)
                    Spacer()
                    
                    
                }
            } else {
                
                VStack {
                    OnboardingSecondView()
                    Spacer()
                    
                }
            
            }
            
        }
        .onAppear(perform: checkKeyboardStatus)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            checkKeyboardStatus()
        }
        .ignoresSafeArea()

    }
    private func checkKeyboardStatus() {
        // 1. isKeyboardEnabled() 함수를 호출하는 것은 어떤 스레드에서 해도 비교적 안전합니다.
        let status = KeyboardPermissionManager.isKeyboardEnabled()
        print(status)
        // 2. ✅ 하지만 그 결과로 UI 상태(@State)를 바꾸는 것은 반드시 메인 스레드에서 해야 합니다.
        DispatchQueue.main.async {
            if isKeyboardEnabled != status {
                isKeyboardEnabled = status
            }
        }
    }
}

//MARK: - OnboardingFristView
private struct OnboardingFristView: View {
    var body: some View {
        VStack {
            Image("OnboardingText")
            
            Spacer()
                .frame(height: 10)
            HStack{
                Spacer()
                Text("어떤 개인 정보도 수집하지 않습니다 :)")
                    .font(.pretendard(size: 18, weight: .medium))
                Spacer()
            }
            Button {
                
                Task {
                    await KeyboardPermissionManager.openAppSettings()
                }
                
                
            } label: {
                Text("설정하기")
                    .font(.pHeadline02)
                    .padding(.horizontal, 144)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(.main)
            .cornerRadius(10)
        }
        .background(Color.white)
    }
    
    
}

// MARK: - OnboardingSecondView
private struct OnboardingSecondView: View {
    private enum Field: Hashable {
        case hiddenTextField
    }
    @FocusState private var focusedField: Field?
    @State private var hiddenText: String = ""
    fileprivate var body: some View {
       
            
        ZStack {
            VStack {
                Image("onbodingImage")
                Spacer()
                TextField("", text: $hiddenText)
                    .focused($focusedField, equals: .hiddenTextField)
                    .opacity(0) // 완전히 투명하게 만듦
                    .allowsHitTesting(false) // 터치 이벤트 무시
            }
            VStack{
                Spacer()
                Button {
                    
                } label: {
                    
                    Text("선택완료")
                        .font(.pHeadline02)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // 좌우 꽉 채우기
                        .background(.main) // .main 대체
                }
                Spacer()
                    .frame(height: 180)
               
            }
            
        }
        .onAppear {
            // 뷰가 그려질 시간을 주기 위해 아주 짧은 딜레이 후 포커스
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusedField = .hiddenTextField
            }
        }
        
    }
}


#Preview {
    OnboardingView()
}
