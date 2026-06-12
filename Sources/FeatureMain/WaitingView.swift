//
//  WaitingView.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation
import SwiftUI
import Shared
import DotLottie
import Domain

public struct WaitingView: View {
    @EnvironmentObject var pathModel: PathModel

    public init() { }

    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    _ = pathModel.paths.popLast()
                }) {
                    Image("close")
                }
            }
            .padding(.horizontal,20)
            Spacer()
                .frame(height: 200)
            
            HStack {
                Spacer()
                (DotLottieAnimation(fileName: "ready", config: AnimationConfig(autoplay: true, loop: true)).view() as DotLottieView)
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
