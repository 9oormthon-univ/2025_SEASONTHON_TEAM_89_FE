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
            
            DotLottieAnimation(fileName: "ready", config: AnimationConfig(autoplay: true, loop: true)).view()
                .scaledToFit()
                .frame(width: 300)
            
            Spacer()
        }

    }
    
}

#Preview {
    WatingView()
}
