//
//  CustomNavigaitonBar.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import SwiftUI

struct CustomNavigationBar: View {
  let isDisplayLeftBtn: Bool
  let isDisplayRightBtn: Bool
  let leftBtnAction: () -> Void
    let leftTitle: String
  init(
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
  
  var body: some View {
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
