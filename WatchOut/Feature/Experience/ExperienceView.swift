//
//  ExperienceView.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import SwiftUI

// 1. Enum 개선: CaseIterable, Identifiable 채택 및 데이터 추가
enum ExperienceType: String, CaseIterable, Identifiable {
    case one = "1"
    case two = "2"
    case three = "3"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .one: return "위험 문장 감지"
        case .two: return "위험도 설정"
        case .three: return "체험 완료"
        }
    }
}

struct ExperienceView: View {
    @State var experienceType: ExperienceType = .one
    @State var text: String = ""
    @FocusState var focused: Bool
    @State var isEnter = false
    @State var sendtext: String = ""
    @EnvironmentObject private var pathModel: PathModel
    var body: some View {
        VStack {
            CustomNavigationBar(leftBtnAction: {pathModel.paths.removeLast()}, leftTitle: "체험하기")
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    // 3. ForEach를 사용해 반복 코드 제거
                    HStack {
                        // ExperienceType의 모든 케이스를 순회
                        ForEach(ExperienceType.allCases) { step in
                            // 각 단계 뷰
                            ExperienceTitle(
                                title: step.title,
                                number: step.rawValue,
                                // 2. 선택 상태를 동적으로 결정
                                isSelected: experienceType == step
                            )
                            .id(step) // 1. ScrollViewReader를 위한 ID 부여
                            
                            // 마지막 단계가 아닐 경우에만 화살표 표시
                            if step != ExperienceType.allCases.last {
                                Image("arrow")
                            }
                        }
                    }
                    .padding()
                }
                .disabled(true)
                .onChange(of: experienceType) { newStep in
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        scrollViewProxy.scrollTo(newStep, anchor: .center)
                    }
                }
            }
            // 현재 선택된 뷰를 보여주는 영역 (예시)
            TabView(selection: $experienceType) {
                ExperienceOneView()
                    .padding(20)
                    .tag(ExperienceType.one)
                ExperienceTwo(text: sendtext, isEnter: isEnter)
                    .padding(20)
                    .tag(ExperienceType.two)
                ExperienceThree(text: sendtext)
                    .padding(20)
                    .tag(ExperienceType.three)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: experienceType) // 부드러운 전환
            Group {
                HStack{
                    Text("지금 돈 넣으면")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .overlay{
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.gray300,lineWidth: 1)
                            
                        }
                        .onTapGesture {
                            text = "지금 300만원 더 넣으면 출금 가능해요?"
                            experienceType = .two
                        }
                    Spacer()
                    Text("수익률 30% 확정")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .overlay{
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.gray300,lineWidth: 1)
                            
                        }
                        .onTapGesture {
                            text = "제 명의로 계좌 만들어서 보내드릴게요"
                            experienceType = .two
                        }
                    Spacer()
                    Text("제 명의로 계좌")
                    
                        
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .overlay{
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.gray300,lineWidth: 1)
                            
                        }
                        .onTapGesture {
                            text = "수익률 30% 확정이라던데 안 되나요?"
                            experienceType = .two
                        }
                }
                .font(.pretendard(size: 14, weight: .medium
                                 ))
                CustomTextField(text: $text, enter: {
                    
                    if experienceType == .two {
                        NotificationManager.instance.scheduleNotification(title: "위험한 문장이 반복 감지되었습니다.", subtitle: "필요하다면 즉시 신고를 도와드 수 있어요.", secondsLater: 1)
                    }
                    
                    if experienceType == .two {
                        experienceType = .three
                        isEnter = true
                        sendtext = text
                        text = ""
                        
                        
                    }
                }, isDisabled: false)
                    .focused($focused)
            }
            .padding(.horizontal, 20)
            Spacer()
                .frame(height: 10)

           
        }
        .onAppear{
            SharedUserDefaults.isTutorial = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationManager.instance.requestAuthorization()
                self.focused = true
            }
        }
        .onDisappear {
            SharedUserDefaults.isTutorial = false
        }
    }
        
}

// MARK: - ExperienceTitle (파라미터를 제대로 사용하도록 수정)
private struct ExperienceTitle: View {
    let title: String
    let number: String
    var isSelected: Bool
    
    fileprivate var body: some View {
        HStack{
            ZStack{
                Image("star") // "Star" 이미지가 없다면 SF Symbol로 대체
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    // isSelected에 따라 색상 변경
                    .foregroundStyle(isSelected ? .main : Color.gray)
                
                Text(number) // 하드코딩된 "1" 대신 파라미터 사용
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.black)
            }
            Text(title) // 하드코딩된 "위험 문장 감지" 대신 파라미터 사용
                .font(.pHeadline02)
        }
        .opacity(isSelected ? 1.0 : 0.4) // 선택 여부에 따라 투명도 조절
    }
}


#Preview {
    ExperienceView()
}
