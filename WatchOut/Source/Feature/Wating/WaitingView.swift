//
//  WaitingView.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation
import SwiftUI
import DotLottie

struct WaitingView: View {
    @EnvironmentObject var pathModel: PathModel
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    pathModel.paths.removeLast()
                }) {
                    Image("close")
                }
            }
            .padding(.horizontal,20)
            Spacer()
                .frame(height: 200)
            
            HStack {
                Spacer()
                DotLottieAnimation(fileName: "ready", config: AnimationConfig(autoplay: true, loop: true)).view()
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
    WaitingView()
}
