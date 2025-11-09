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
                    .foregroundStyle(.riskColor1)
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
                                       appState.isLoggedIn = true
                                   } else {
                                       print("최종 로그인 실패")
                                   }
                               }
                } label: {
                    Image("kakao_login_large_wide 1")
                }
                Spacer()
                    .frame(height: 20)
            }
        }
        .onChange(of: appState.isLoggedIn) {
            UserManager.shared.loadUserFromUserDefaults()
        }
        .overlay {
            if loginViewModel.isLoading {
                LoadingView()
            }
        }
    }
}
