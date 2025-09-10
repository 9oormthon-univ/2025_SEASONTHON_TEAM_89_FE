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

            Text("준비 중...")
                .font(.gHeadline01)
            Spacer()
        }

    }
    
}

#Preview {
    WatingView()
}
