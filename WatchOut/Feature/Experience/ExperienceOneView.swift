//
//  ExperienceOneView.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import SwiftUI

struct ExperienceOneView: View {
    @State var text: String = ""
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("문장을 선택하거나 직접 입력해 보세요")
                        .font(.pHeadline01)
                    Spacer()
                        .frame(height: 12)
                    Text("입력 중에는 이전 문장 흐름까지 함께 고려해 판단해요.")
                        .font(.pSubtitle03)
                        .foregroundStyle(.gray300)
                    Text("추천 문장 : 멘토님,  돈 넣으면 출금 가능해요?")
                        .font(.pSubtitle03)
                        .foregroundStyle(.main)
                    
                }
                Spacer()
            }
            VStack {
                
                Spacer()
                    .frame(height: 30)
                HStack {
                    Text("여기에 돈 지금 당장 넣어주세요!")
                        .padding()
                        .background(.gray100)
                        .cornerRadius(24)
                    Spacer()
                }
                Spacer()
                    .frame(height: 20)
                
                HStack {
                    Spacer()
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
    ExperienceOneView()
}
