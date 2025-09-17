//
//  JoinGroupView.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import SwiftUI

struct JoinGroupView: View {
    @EnvironmentObject private var pathModel: PathModel
    @State var groupCode: String = ""
    @State var userName: String = ""
    var body: some View {
        VStack {
            CustomNavigationBar(leftBtnAction: {
                pathModel.paths.removeLast()
            }, leftTitle: "")
            HStack(alignment: .bottom) {
                VStack {
                    
                    Text("그룹 입장하기")
                        .font(.gHeadline01)
                }
                Spacer()
                Image("JoinGroup")
            }
            .padding(.horizontal, 20)
            HStack {
                Text("입력 중에는 이전 문장 흐름까지 함께 고려해 판단해요.")
                    .font(.pSubtitle03)
                    .foregroundStyle(.gray300)
                Spacer()
            }
            .padding(.horizontal,20)
            Spacer()
                .frame(height: 40)
            VStack{
                
                HStack {
                    Text("사용할 별명")
                        .font(.pHeadline01)
                    Text( "최대 6자")
                        .foregroundStyle(.gray400)
                        .font(.pSubtitle03)
                    Spacer()
                }
                
                TextField("그룹 이름을 정해주세요.", text: $userName)
                    .font(.pBody01)
                    .padding()
                    .background()
                    .cornerRadius(47)
                    .overlay {
                        RoundedRectangle(cornerRadius: 47)
                            .stroke(.gray300,lineWidth:     1)
                    }
                
                Spacer()
                    .frame(height: 50)
                
                VStack {
                    HStack {
                        Text("그룹 참여 코드")
                            .font(.pHeadline01)
                            .padding(.bottom,5)
                        
                        Spacer()
                    }
                    HStack {
                        Text( "방장에게 받은 참여 코드를 입력해주세요.")
                            .padding(.bottom,5)
                            .foregroundStyle(.gray400)
                            .font(.pSubtitle03)
                        Spacer()
                    }
                   
                }
                
                TextField("사용하실 별명을 정해주세요.", text: $groupCode)
                    .font(.pBody01)
                    
                    .padding(
                        
                    )
                    .background()
                    .cornerRadius(47)
                    .overlay {
                        RoundedRectangle(cornerRadius: 47)
                            .stroke(.gray300,lineWidth:     1)
                    }
                Spacer()
                Button {

                } label: {
                    Spacer()
                    Text("입장하기")
                        .font(.pHeadline02)
                        .padding(.vertical, 12)
                    Spacer()
                
                }
                
                .buttonStyle(.borderedProminent)
                .tint(.main)
                .cornerRadius(10)
                Spacer()
                    .frame(height: 10)
            }
            .padding(.vertical,48)
            .padding(.horizontal, 20)
            .background(.gray100)
            .cornerRadius(48)
            
            
        }
    }

}

#Preview {
    JoinGroupView()
}
