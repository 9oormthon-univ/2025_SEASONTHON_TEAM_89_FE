//
//  loadingView.swift
//  WatchOut
//
//  Created by 어재선 on 11/8/25.
//

import SwiftUI
import DotLottie

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 200)
            
            HStack {
                Spacer()
                DotLottieAnimation(fileName: "loading", config: AnimationConfig(autoplay: true, loop: true)).view()
                    .scaledToFit()
                    .frame(width: 300)
                Spacer()
            }
            Spacer()
        }
        .background(Color(.systemBackground))

    }
    
}

#Preview {
    LoadingView()
}
