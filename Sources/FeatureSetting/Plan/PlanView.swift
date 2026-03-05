//
//  PlanView.swift
//  WatchOut
//
//  Created by 어재선 on 11/8/25.
//

import SwiftUI

struct PlanView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var planViewModel = PlanViewModel()
    var body: some View {
        VStack(alignment: .center) {
            NavigationBar()
            Spacer()
                .frame(height: 30)
            TitleView()
            Spacer()
                .frame(height: 26)
            Picker("",selection: $planViewModel.selectedType) {
                ForEach(PlanType.allCases,id: \.self) { plan in
                    Text(plan.rawValue)
                }
            }
            .fixedSize()
            .pickerStyle(.segmented)
            if planViewModel.selectedType == .individual {
                PlanIndividualRow(viewModel: planViewModel, type: .basic, subTitles:  [
                    "기본 테마",
                    "기본 패턴 감지",
                    "본인에게 경고 알림 (팝업 및 진동)"
                ]
                )
                Spacer()
                    .frame(height: 12)
                PlanIndividualRow(viewModel: planViewModel, type: .plus, subTitles:  [
                    "광고 제거",
                    "프리미엄 테마 제공",
                    "고도화된 문맥/ 패턴 감지",
                    "경고 시 키보드 잠금 기능"
                ]
                )
            } else {
                PlanFamilyRow(viewModel: planViewModel, type: .familyA, subTitles: [
                    "광고 제거",
                    "프리미엄 테마 제공",
                    "고도화된 문맥/ 패턴 감지",
                    "경고 시 가족 그룹 실시간 경고"],
                )
                Spacer()
                    .frame(height: 12)
                PlanFamilyRow(viewModel: planViewModel, type: .familyB, subTitles: [
                    "광고 제거",
                    "프리미엄 테마 제공",
                    "고도화된 문맥/ 패턴 감지",
                    "경고 시 가족 그룹 실시간 경고"], )
            }
            Spacer()
                .frame(height: 24)
            Button {
                pathModel.paths.append(.waitingView)
            } label: {
                HStack {
                    Spacer()
                    Text("구매하기")
                        .font(.pHeadline03)
                        .padding(.vertical, 18)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .background(planViewModel.selectedPlan.isEmpty ? .gray300 : .main)
                .cornerRadius(8)
            }.disabled(planViewModel.selectedPlan.isEmpty)
            Spacer()
        
        }
        .padding(.horizontal, 20)
        .onChange(of: planViewModel.selectedPlan) {
            if planViewModel.selectedPlan == planViewModel.isCurrentlyUsed {
                planViewModel.selectedPlan = ""
            }
        }
    }
    
}

//MARK: - PlanFamilyRow
private struct PlanFamilyRow: View {
    @ObservedObject var viewModel: PlanViewModel
    let type: Family
    let subTitles: [String]
    

    fileprivate var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(type.rawValue)
                    .font(.pHeadline01)
                
                if viewModel.isCurrentlyUsed == type.rawValue {
                    Text("사용중")
                        .font(.pCaption01)
                        .foregroundStyle(.main)
                }
                Spacer()
                
                if type == .familyA {
                   HStack(alignment: .bottom){
                       Text("12,000원")
                           .font(.pHeadline01)
                           .foregroundStyle(.main)
                       Text("/연")
                           .font(.pCaption01)
                           .foregroundStyle(.gray400)
                   }
                } else if type == .familyB {
                    HStack(alignment: .bottom){
                        Text("23,000원")
                            .font(.pHeadline01)
                            .foregroundStyle(.main)
                        Text("/연")
                            .font(.pCaption01)
                            .foregroundStyle(.gray400)
                    }
                    
                }
            }
            Spacer()
                .frame(height: 13)
            if type == .familyA {
                Text("- 그룹 최대 4인 가능")
                    .font(.pBody02)
            } else if type == .familyB {
                Text("- 그룹 5인 ~ 10인 가능")
            }
            ForEach(subTitles, id: \.self) {
                Text( "- \($0)")
                    .font(.pBody02)
                    .foregroundStyle(viewModel.selectedPlan == type.rawValue ? .black : .gray400)
            }
        }
        .padding(20)
        .background(viewModel.selectedPlan == type.rawValue ?  .main.opacity(0.1): .gray100.opacity(0.5))
        .cornerRadius(14, corners: .allCorners)
        .overlay {
            if viewModel.selectedPlan == type.rawValue {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.main)
            }
            
        }
        .onTapGesture {
            viewModel.selectedPlan = type.rawValue
        }
        
    }
}

//MARK: - PlanIndividualRow
private struct PlanIndividualRow: View {
    @ObservedObject var viewModel: PlanViewModel
    let type: Individual
    let subTitles: [String]

    fileprivate var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(type.rawValue)
                    .font(.pHeadline01)
                
                if viewModel.isCurrentlyUsed == type.rawValue {
                    Text("사용중")
                        .font(.pCaption01)
                        .foregroundStyle(.main)
                }
                Spacer()
                
                if type == .basic {
                    Text("Free")
                        .font(.pHeadline01)
                } else if type == .plus {
                    HStack(alignment: .bottom){
                        Text("7,500원")
                            .font(.pHeadline01)
                            .foregroundStyle(.main)
                        Text("/연")
                            .font(.pCaption01)
                            .foregroundStyle(.gray400)
                    }
                    
                }
            }
            Spacer()
                .frame(height: 13)
            ForEach(subTitles, id: \.self) {
                Text( "- \($0)")
                    .font(.pBody02)
                    .foregroundStyle(viewModel.selectedPlan == type.rawValue ? .black : .gray400)
            }
        }
        .padding(20)
        .background(viewModel.selectedPlan == type.rawValue ?  .main.opacity(0.1): .gray100.opacity(0.5))
        .cornerRadius(14, corners: .allCorners)
        .overlay {
            if viewModel.selectedPlan == type.rawValue {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.main)
            } else {
                if type == .plus {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                LinearGradient(
                                    stops: [
                                        .init(color: .orange, location: 0.0),
                                        .init(color: .red, location: 0.59),
                                        .init(color: .purple, location: 1.0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        VStack {
                            HStack {
                                Spacer()
                                Image("messagebox")
                                    .padding(.trailing,30)
                                    .offset(y:-20)
                            }
                            Spacer()
                        }
                        
                     
                    }
                }
            }
            
        }
        .onTapGesture {
            viewModel.selectedPlan = type.rawValue
        }
        
    }
}

// MARK: - NavigationBar

private struct NavigationBar :View {
    @EnvironmentObject var pathModel: PathModel
    fileprivate var body: some View {
        HStack {
            Spacer()
            Button(action: {
                _ = pathModel.paths.popLast()
            }) {
                Image("close")
            }
        }
    }
}

// MARK: - TitleView
private struct TitleView :View {
    fileprivate var body: some View {
        VStack(spacing: 12){
            Image("planviewIcon")
            Text("\(UserManager.shared.currentUser?.nickname ?? "")님에게 맞는\n플랜을 선택해 보세요")
                .font(.pHeadline01)
                .multilineTextAlignment(.center)
            Text("가족들과 함께 위허메 키보드를 사용하고 계시다면,\n패밀리 플랜을 권장드려요.")
                .font(.pBody02)
                .foregroundStyle(.gray400)
                .multilineTextAlignment(.center)
            
        }
    }
}

// MARK:

#Preview {
    PlanView()
}
