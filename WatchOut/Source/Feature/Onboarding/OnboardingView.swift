//
//  OnboardingView.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import SwiftUI
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
            if !onboardingViewModel.getIsKeyboardEnabled() {
                ZStack {
                    DotLottieAnimation(
                        fileName: "animation", 
                        config: AnimationConfig(autoplay: true, loop: true)
                    ).view()
                    
                    VStack {
                        Spacer()
                        OnboardingFirstView()
                    }
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

//MARK: - OnboardingFirstView
private struct OnboardingFirstView: View {
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
                .frame(height: 50)
            
            Image("OnboardingText")
            
            Text("어떤 개인 정보도 수집하지 않습니다 :)")
                .font(.pretendard(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                Task {
                    await KeyboardPermissionManager.openAppSettings()
                }
            } label: {
                Text("설정하기")
                    .font(.pHeadline02)
                    .foregroundColor(.white)
                    .padding(.horizontal, 144)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(.main)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .background(Color.white)
    }
}

// MARK: - OnboardingSecondView
private struct OnboardingSecondView: View {
    @EnvironmentObject private var pathModel: PathModel
    @FocusState private var focusedField: Field?
    @State private var hiddenText: String = ""
    
    private enum Field: Hashable {
        case hiddenTextField
    }
    
    var body: some View {
        ZStack {
            VStack {
                Image("onbodingImage")
                Spacer()
            }
            
            VStack {
                TextField("", text: $hiddenText)
                    .focused($focusedField, equals: .hiddenTextField)
                    .opacity(0)
                    .allowsHitTesting(false)
                    .frame(height: 0)
                Spacer()
                
                Button {
                    pathModel.paths.append(.mainTabView)
                    SharedUserDefaults.isOnboarding = true
                } label: {
                    Text("선택완료")
                        .font(.pHeadline02)
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.main)
                }
                
            }
        }
        .ignoresSafeArea(.container)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .hiddenTextField
            }
        }
    }
}


#Preview {
    OnboardingView()
}
