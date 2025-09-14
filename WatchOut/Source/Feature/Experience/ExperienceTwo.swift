//
//  ExperienceTwo.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import SwiftUI

struct ExperienceTwo: View {
    let text: String
    let isEnter: Bool
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("위허메 키보드의 반응을  확인해요")
                        .font(.pHeadline01)
                    Spacer()
                        .frame(height: 12)
                    Text("문장 위험도를 판단하고 그에 맞는 신호를 보여줄 거예요.")
                        .font(.pSubtitle03)
                        .foregroundStyle(.gray300)
                    Text("주황색은 경고, 빨간색은 위험 신호에요!")
                        .font(.pSubtitle03)
                        .foregroundStyle(.gray300)
                    
                }
                Spacer()
                
            }
            Spacer()
                .frame(height: 30)
            VStack {
                HStack {
                    Text("여기에 돈 지금 당장 넣어주세요!")
                        .padding()
                        .background(.gray100)
                        .cornerRadius(24)
                    Spacer()
                }
                
            }
            Spacer()
                .frame(height: 20)
            
            HStack {
                Spacer()
                if isEnter {
                    Text(text)
                        .font(.pBody02)
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.gray300,lineWidth: 1)
                        }
                } else {
                    Text("  . . .  ")
                        .font(.pBody02)
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.gray300,lineWidth: 1)
                        }
                }
            }
            Spacer()
            
        }
    }
    
}


#Preview {
    ExperienceTwo(text: "",isEnter: false)
}
