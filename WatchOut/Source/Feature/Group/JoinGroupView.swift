//
//  JoinGroupView.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import SwiftUI

struct JoinGroupView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var groupViewModel = GroupViewModel()
    var body: some View {
        VStack {
            CustomNavigationBar(leftBtnAction: {
                _ = pathModel.paths.popLast()
            }, leftTitle: "")
            ScrollView{
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
                    
                    TextField("사용할 별명을 입력하세요", text: $groupViewModel.userName)
                        .font(.pBody01)
                        .padding()
                        .background()
                        .cornerRadius(47)
                        .overlay {
                            RoundedRectangle(cornerRadius: 47)
                                .stroke(.gray300,lineWidth: 1)
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
                    
                    TextField("코드입력", text: $groupViewModel.groupCode)
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
                        .frame(height: 200)
                    Button {
                        groupViewModel.joinGroupAction()
                        
                    } label: {
                        Spacer()
                        Text("입장하기")
                            .font(.pHeadline02)
                            .padding(.vertical, 18)
                            .foregroundStyle(.white)
                        Spacer()
                    
                    }
                    .background(.main)
                    .cornerRadius(8)
                    Spacer()
                        .frame(height: 10)
                }
                .padding(.vertical,48)
                .padding(.horizontal, 20)
                .background(.gray100)
                .cornerRadius(48)
            }
            
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .onChange(of: groupViewModel.isJoinGroup) {
            _ = pathModel.paths.popLast()
            pathModel.paths.append(.managementGroupView)
        }
        .onDisappear {
            groupViewModel.groupCode = ""
            groupViewModel.userName = ""
        }
        .alert("오류", isPresented: $groupViewModel.showError) {
                    Button("확인", role: .cancel) {
                        _ = pathModel.paths.popLast()
                    }
                } message: {
                    Text(groupViewModel.errorMessage)
                }
        
    }

}

#Preview {
    JoinGroupView()
}
