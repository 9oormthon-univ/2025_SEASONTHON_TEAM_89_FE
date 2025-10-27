//
//  CreateGroup.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25
//

import SwiftUI

struct CreateGroupView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var groupViewModel: GroupViewModel
    
    var body: some View {
        VStack {
            CustomNavigationBar(leftBtnAction: {
                pathModel.paths.removeLast()
            }, leftTitle: "")
            ScrollView {
                HStack(alignment: .bottom) {
                    VStack {
                        
                        Text("그룹만들기")
                            .font(.gHeadline01)
                    }
                    Spacer()
                    Image("GroupIcon")
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
                ZStack {
                    RoundedRectangle(cornerRadius: 48)
                        .foregroundStyle(.gray100)
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                    VStack{
                        
                        HStack {
                            Text("그룹 이름")
                                .font(.pHeadline01)
                            Text( "최대 8자")
                                .foregroundStyle(.gray400)
                                .font(.pSubtitle03)
                            Spacer()
                        }
                        
                        TextField("그룹 이름을 정해주세요.", text: $groupViewModel.groupName)
                            .font(.pBody01)
                            .padding()
                            .background()
                            .cornerRadius(47)
                            .overlay {
                                RoundedRectangle(cornerRadius: 47)
                                    .stroke(.gray300,lineWidth:     1)
                            }
                        Spacer()
                            .frame(height: 52)
                        
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
                            .background()
                            .cornerRadius(47)
                            .overlay {
                                RoundedRectangle(cornerRadius: 47)
                                    .stroke(.gray300,lineWidth:     1)
                            }
                        
                        Spacer()
                            .frame(height: 230)
                        
                        Button {
                            groupViewModel.CreateGorupAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text("만들기")
                                    .font(.pHeadline02)
                                    .padding(.vertical, 18)
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .background(.main)
                            .cornerRadius(8)
                        }
                      Spacer()
                    }
                    .padding(.vertical,48)
                    .padding(.horizontal, 20)
                }
                .ignoresSafeArea(.keyboard)
               
            }
                        
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .onChange(of: groupViewModel.isCreate) {
            if groupViewModel.isCreate {
                pathModel.paths.removeLast()
                pathModel.paths.append(.managementGroupView)
            }
        }
        .onDisappear {
            groupViewModel.userName = ""
            groupViewModel.groupName = ""
        }
    }
}

#Preview {
    CreateGroupView()
}
