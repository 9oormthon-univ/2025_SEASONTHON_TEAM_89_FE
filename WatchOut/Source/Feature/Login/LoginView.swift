//
//  LoginView.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoggedIn {
                Text("로그인 성공!")
                    .font(.largeTitle)
                    .padding()
                
                Button("로그아웃 (토큰 삭제)") {
                    TokenManager.shared.clearAllTokens()
                    viewModel.isLoggedIn = false
                }
            } else {
                Text("소셜 로그인 테스트")
                    .font(.title)
                    .padding()

                // 카카오 로그인 버튼
                Button {
                    viewModel.handleKakaoLogin()
                } label: {
                    Image("kakao_login_large_wide 1") // 카카오 공식 로그인 버튼 이미지 에셋
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)
                }
            }
        }
    }
}
