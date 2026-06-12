//
//  OnboardingView.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import SwiftUI
import DotLottie
import Domain
import Platform
import DesignSystem

public struct OnboardingView: View {
    @StateObject private var onboardingContentViewModel = OnboardingContentViewModel()

    public init() { }

    public var body: some View {
        OnboardingContentView(onboardingViewModel: onboardingContentViewModel)
            .onAppear(perform: UserManager.shared.loadUserFromUserDefaults)
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
                    (DotLottieAnimation(
                        fileName: "guidevideo",
                        config: AnimationConfig(autoplay: true, loop: true)
                    ).view() as DotLottieView)

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
                Image("onboardingImage")
                Spacer()
            }

            VStack {
                Spacer()

                Button {
                    SharedUserDefaults.isOnboarding = true
                    pathModel.paths.append(.mainTabView)
                } label: {
                    VStack {
                        Text("선택완료")
                            .font(.pHeadline02)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 58)
                .background(Color.main)

                TextField("", text: $hiddenText)
                    .focused($focusedField, equals: .hiddenTextField)
                    .opacity(0)
                    .allowsHitTesting(false)
                    .frame(height: 39)
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
