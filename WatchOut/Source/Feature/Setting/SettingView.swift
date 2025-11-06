//
//  SettingView.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import SwiftUI

struct SettingView: View {
    
    @StateObject private var settingViewModel = SettingViewModel()
    var body: some View {
        VStack {
            Group{
                SubTitle(text: "경고 아이콘 색상 변경")
                VStack(spacing: 20){
                    ColorPickerView(settingViewModel: settingViewModel, iconName: "status1", text: "주의", status: .warning)
                        .onTapGesture {
                            settingViewModel.isShowSheet = true
                            settingViewModel.setStatus(status: .warning)
                        }
                    ColorPickerView(settingViewModel: settingViewModel, iconName: "status2", text: "위험", status: .danger)
                        .onTapGesture {
                            settingViewModel.isShowSheet = true
                                settingViewModel.setStatus(status: .danger)
                        }
                }
            }
            .padding(.horizontal,20)
            
            CustomDivider()
            Group{
                SubTitle(text: "경고 알림")
                VStack(spacing: 20) {
                    NotificationSettingView(settingViewModel: settingViewModel, status: .warning)
                    
                    NotificationSettingView(settingViewModel: settingViewModel, status: .danger)
                }
            }
            .padding(.horizontal,20)
            Spacer()
        }
        .sheet(isPresented: $settingViewModel.isShowSheet) {
            SheetView(settingViewModel: settingViewModel, status: settingViewModel.getStatus())
                .presentationDragIndicator(.visible)
                .presentationDetents([.extraLarge])
        }
     
 
    }
}
// MARK: - SheetView
private struct SheetView: View {
    @ObservedObject var settingViewModel: SettingViewModel
    let status: Status
    fileprivate var body: some View {
        VStack {
            Spacer()
            Text("\(status.rawValue) 색상 변경")
                .font(.pHeadline03)
            Spacer()
                .frame(height: 8)
            Text("\(status.rawValue) 경고 시 나타낼 색상을 선정해 주세요")
                .font(.pSubtitle03)
                .foregroundStyle(.gray400)
            Spacer()
                .frame(height: 24)
            VStack {
                let columns: [GridItem] = [
                    GridItem(.adaptive(minimum: 36), spacing:18)
                ]
                LazyVGrid(columns:columns,alignment: .leading) {
                    ForEach(Range(1...14), id: \.self) { index in
                        Circle()
                            .foregroundStyle(Color( "RiskColor\(index)"))
                            .frame(width: 24,height: 24)
                            .padding(4)
                            .overlay{
                                if settingViewModel.getRiskLevelColor(level: status) == "\(index)" {
                                    Circle()
                                        .stroke(.gray200, lineWidth: 1)
                                }
                                
                            }
                            .onTapGesture {
                                settingViewModel.setRiskLevelColor(level: status, color: String(index))
                            }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            ZStack {
                Image("KeyboardImage")
                Image("KeyboardStatusImage")
                    .foregroundStyle(Color("RiskColor\(settingViewModel.getRiskLevelColor(level: status))"))
            }
        }
    }
}
// MARK: - CustomDivider
private struct CustomDivider: View {
    fileprivate var body: some View {
        Rectangle()
            .frame(height: 8)
            .foregroundStyle(.gray100)
    }
}


// MARK: - subTitleView
private struct SubTitle: View {
    let text: String
    fileprivate var body: some View {
        HStack {
            Text(text)
                .font(.pHeadline03)
                .foregroundStyle(.main)
            Spacer()
        }
    }
}

// MARK: - ColorPickerView
private struct ColorPickerView: View {
    @ObservedObject var settingViewModel: SettingViewModel
    let iconName: String
    let text: String
    let status: Status
    fileprivate var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 36)
            
                .foregroundStyle(Color("RiskColor\(settingViewModel.getRiskLevelColor(level: status))"))
            Text(text)
                .font(.pBody02)
            Spacer()
            Image(systemName: "chevron.down")
            
        }
    }
}

// MARK: - NotificationSettingView
private struct NotificationSettingView: View {
    @ObservedObject var settingViewModel: SettingViewModel
    let status: Status
    fileprivate var body: some View {
        HStack {
            Text(status.rawValue)
                .font(.pBody02)
            Spacer()
            
            if status == .warning {
                Toggle("진동", isOn: $settingViewModel.isWarningHaptic)
                    .font(.pBody02)
                    .tint(.main)
                    .frame(width: 100)
                
                
                
                Toggle("팝업", isOn: $settingViewModel.isWarningNotification)
                    .font(.pBody02)
                    .tint(.main)
                    .frame(width: 100)
            } else {
                Toggle("진동", isOn: $settingViewModel.isDangerHaptic)
                    .font(.pBody02)
                    .tint(.main)
                    .frame(width: 100)
                
                
                
                Toggle("팝업", isOn: $settingViewModel.isDangerNotification)
                    .font(.pBody02)
                    .tint(.main)
                    .frame(width: 100)
            }
            
        }
    }
}
#Preview {
    SettingView()
}
