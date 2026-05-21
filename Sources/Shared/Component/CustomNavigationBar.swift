//
//  CustomNavigationBar.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import SwiftUI

public struct CustomNavigationBar: View {
    public let isDisplayLeftBtn: Bool
    public let isDisplayRightBtn: Bool
    public let leftBtnAction: () -> Void
    public let leftTitle: String
    
    public init(
        isDisplayLeftBtn: Bool = true,
        isDisplayRightBtn: Bool = true,
        leftBtnAction: @escaping () -> Void = {},
        leftTitle: String
    ) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.leftTitle = leftTitle
    }
    
    public var body: some View {
        HStack {
            if isDisplayLeftBtn {
                Button(
                    action: leftBtnAction,
                    label: { Image("leftIcon") }
                )
                Text(leftTitle)
                    .font(.pHeadline02)
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
    }
}


#Preview {
    CustomNavigationBar(isDisplayLeftBtn: true, isDisplayRightBtn: false, leftBtnAction: {}, leftTitle: "체험하기")
}
