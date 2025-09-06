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
            SubTitle(text: "경고 아이콘 색상 변경")
            
            SubTitle(text: "위험 알림")
        }
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
    let text: String
    fileprivate var body: some View {
        HStack {
            Image("star")
                .foregroundStyle(.main)
            Text(text)
                .font(.pBody02)
            Spacer()
            Image("chevron.down")
        }
    }
}
#Preview {
    SettingView()
}
