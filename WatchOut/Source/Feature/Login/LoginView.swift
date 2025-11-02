//
//  LoginView.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @EnvironmentObject private var appState: AppState
    var body: some View {
        
        ZStack {
            Image("loginbackgroundImage")
            VStack(alignment: .center) {
                Spacer()
                    .frame(height: 100)
                Image("status1")
                    .foregroundStyle(.riskColor2)
                Text("환영합니다.")
                    .font(.gHeadline01)
                Spacer()
                    .frame(height: 21)
                Text("편리한 키보드 활용을 위해")
                    .font(.pHeadline02)
                    .foregroundStyle(.gray500)
                    
                Text("로그인을 해주세요.")
                    .font(.pHeadline02)
                    .foregroundStyle(.gray500)
                
                Spacer()
                Button {
                    loginViewModel.handleKakaoLogin { success in
                                   if success {
                                       // 로그인 성공 시, View가 직접 appState를 업데이트
                                       
                                       appState.isLoggedIn = true
                                   } else {
                                       // 로그인 실패 시 사용자에게 알림 (예: Alert)
                                       print("최종 로그인 실패")
                                   }
                               }
                } label: {
                    Image("kakao_login_large_wide 1") // 카카오 공식 로그인 버튼 이미지 에셋
                }
                Spacer()
                    .frame(height: 20)
            }
        }
    }
}
