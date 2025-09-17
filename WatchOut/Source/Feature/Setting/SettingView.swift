//
//  SettingView.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
            Group{
                SubTitle(text: "경고 아이콘 색상 변경")
                VStack(spacing: 20){
                    ColorPickerView(iconName: "status1", text: "주의", status: .warning)
                    ColorPickerView(iconName: "status2", text: "위험", status: .danger)
                }
                
                
            }
            .padding(.horizontal,20)
            
            CustomDivider()
            Group{
                SubTitle(text: "경고 알림")
                VStack(spacing: 20) {
                    NotificationSettingView(status: .warning)
                    
                    NotificationSettingView(status: .danger)
                }
            }
            .padding(.horizontal,20)
            
            Spacer()
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
    let iconName: String
    let text: String
    let status: Status
    fileprivate var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 36)
            
                .foregroundStyle(status == . warning ? .main : .riskColor1)
            Text(text)
                .font(.pBody02)
            Spacer()
            Image(systemName: "chevron.down")
            
        }
    }
}

// MARK: - NotificationSettingView
private struct NotificationSettingView: View {
    let status: Status
    fileprivate var body: some View {
        HStack {
            Text(status == .warning ? "주의" : "위험")
                .font(.pBody02)
            Spacer()
            
            
            Toggle("진동", isOn: .constant(true))
                .font(.pBody02)
                .tint(.main)
                .frame(width: 100)
            
            
            
            Toggle("팝업", isOn: .constant(true))
                .font(.pBody02)
                .tint(.main)
                .frame(width: 100)
        }
    }
}
#Preview {
    SettingView()
}
