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
                    
                    TextField(groupViewModel.user.nickname, text: $groupViewModel.userName)
                        .font(.pBody01)
                        .padding()
                        .background(groupViewModel.userNameMessage.isEmpty  ? .white : .red.opacity(0.1))
                        .cornerRadius(47)
                        .overlay {
                            RoundedRectangle(cornerRadius: 47)
                                .stroke(groupViewModel.userNameMessage.isEmpty  ? .gray300 : .red ,lineWidth: 1)
                        }
                    ZStack {
                        Spacer()
                            .frame(height: 50)
                        VStack {
                            HStack{
                                if !groupViewModel.userNameMessage.isEmpty {
                                    Text(groupViewModel.userNameMessage)
                                        .font(.pCaption01)
                                        .foregroundColor(.red)
                                    Spacer()
                                        
                                }
                            }
                            Spacer()
                        }
                    }
                    
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
                        .background(groupViewModel.groupCodeMessage.contains("존재하지 않는 코드입니다") ? .red.opacity(0.1) : .white)
                        .cornerRadius(47)
                        .overlay {
                            RoundedRectangle(cornerRadius: 47)
                                .stroke(groupViewModel.groupCodeMessage.contains("존재하지 않는 코드입니다") ? .red : .gray300, lineWidth:1)
                        }
                    ZStack {
                        Spacer()
                            .frame(height: 200)
                        VStack {
                            HStack{
                                if groupViewModel.isValidGroupCodeLoding {
                                    ProgressView()
                                } else {
                                    if !groupViewModel.groupCodeMessage.isEmpty {
                                        Text(groupViewModel.groupCodeMessage)
                                            .font(.pCaption01)
                                            .foregroundColor(groupViewModel.groupCodeMessage.contains("존재하지 않는 코드입니다") ? .red : .green)
                                        
                                            
                                    }
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                    }
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
                    .disabled(!groupViewModel.isJoinButtonEnabled)
                    .background(groupViewModel.isJoinButtonEnabled ? .main : .gray400)
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
