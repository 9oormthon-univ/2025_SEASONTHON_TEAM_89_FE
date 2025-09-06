//
//  OnboardingView.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import SwiftUI
import UIKit
import Combine
import DotLottie

struct OnboardingView: View {
    
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingContentViewModel = OnboardingContentViewModel()
    @StateObject private var maintTabViewModel = MainTabViewModel()
    @StateObject private var groupViewModel = GroupViewModel()
    let isOnBoarding = SharedUserDefaults.isOnboarding
   
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
                OnboardingContentView(onboardingViewModel: onboardingContentViewModel)
                .navigationDestination(for: PathType.self, destination: { pathType in
                    switch pathType {
                    case .mainTabView:
                        MainTabView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(maintTabViewModel)
                        
                    case .exprienceView:
                        ExperienceView()
                            .navigationBarBackButtonHidden()
                    case .createGroupView:
                        CreateGroupView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(groupViewModel)
                    case .joinGroupView:
                        JoinGroupView()
                            .navigationBarBackButtonHidden()
                    case .waitingGroupView:
                        WaitingGroupView()
                            .navigationBarBackButtonHidden()
                    case .managementGroupView:
                        ManagementGroupView()
                            .navigationBarBackButtonHidden()
                    }
                    
                })
        }
        .onAppear{
            if isOnBoarding {
                pathModel.paths.append(.mainTabView)
            }
        }
        .environmentObject(pathModel)
       
    }
   
}

//MARK: - OnboardingContentView
private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingContentViewModel
    
      fileprivate init(onboardingViewModel: OnboardingContentViewModel) {
        self.onboardingViewModel = onboardingViewModel
      }
    fileprivate var body: some View {
        ZStack {

            if !onboardingViewModel.getIsKeyboardEnabled()
            {
                VStack {
                    DotLottieAnimation(fileName: "animation", config: AnimationConfig(autoplay: true, loop: true)).view()
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
        .onAppear(perform: onboardingViewModel.checkKeyboardStatus)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            onboardingViewModel.checkKeyboardStatus()
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
    
    @EnvironmentObject private var pathModel: PathModel
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
                    
            }
            VStack{
                Spacer()
                Button {
                    pathModel.paths.append(.mainTabView)
                    SharedUserDefaults.isOnboarding = true
                } label: {
                    
                    Text("선택완료")
                        .font(.pHeadline02)
                        .foregroundColor(.white)
                        .padding(30)
                        .frame(maxWidth: .infinity) // 좌우 꽉 채우기
                        .background(.main) // .main 대체
                }
                TextField("", text: $hiddenText)
                    .focused($focusedField, equals: .hiddenTextField)
                    .opacity(0) // 완전히 투명하게 만듦
                    .allowsHitTesting(false) // 터치 이벤트 무시
               
            }
            
        }
        .ignoresSafeArea(.container)
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
