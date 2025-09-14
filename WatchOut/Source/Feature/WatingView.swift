//
//  WatingView.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation
import SwiftUI
import DotLottie

struct WatingView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 200)
            
            DotLottieAnimation(fileName: "wating", config: AnimationConfig(autoplay: true, loop: true)).view()
                .frame(width: 160, height: 115)

            HStack {
                Text("준비 중")
                    .font(.gHeadline01)
                DotLottieAnimation(fileName: "wating1", config: AnimationConfig(autoplay: true, loop: true)).view()
                    .scaledToFit()
                    .frame(width: 30, height: 30)

            }
            
            Spacer()
        }

    }
    
}

#Preview {
    WatingView()
}
