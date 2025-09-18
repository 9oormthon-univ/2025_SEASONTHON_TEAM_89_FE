//
//  ManagementGroupView.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import SwiftUI

struct ManagementGroupView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var groupViewModel: GroupViewModel
    @EnvironmentObject private var userManager: UserManager
    
    var body: some View {
        VStack {
            CustomNavigationBar(leftBtnAction: {
                pathModel.paths.removeLast()
            }, leftTitle: "")
            ScrollView {
                Spacer()
                    .frame(height: 20)
                HStack(alignment: .bottom) {
                    VStack {
                        HStack {
                            Text(groupViewModel.infoGroupRespose.groupName)
                                .font(.gHeadline01)
                            Text("총 \(groupViewModel.infoGroupRespose.memberCount) 명")
                        }
                        
                    }
                    Spacer()
                    
                }
                .padding(.leading, 20)
                HStack {
                    Text("그룹 참여 코드")
                        .font(.pSubtitle03)
                        .foregroundStyle(.gray300)
                    Spacer()
                    Text(groupViewModel.infoGroupRespose.joinCode)
                        .font(.pBody01)
                        .underline()
                    Button {
                        
                    } label: {
                        Image("CopyIcon")
                    }
                    
                }
                .padding(.horizontal,20)
                Spacer()
                    .frame(height: 20)
                ScrollView(.horizontal, showsIndicators: false){
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        ForEach(groupViewModel.infoGroupRespose.members, id: \.userID) { member in
                            profileView(member: member)
                                .onTapGesture {
                                    groupViewModel.selectMembers = member
                                }
                            
                        }
                    }
                    Spacer()
                }
                
                UserInfoView()
            }
        }
        .alert(isPresented: $groupViewModel.isLeave) {
            Alert(title: Text("그룹을 해체하시겠습니까?"), message: Text("그룹을 해체하면 모든 그룹원이 강퇴됩니다."), primaryButton: .destructive(Text("나가기"), action: {
                groupViewModel.LeaveGorupAction()
                pathModel.paths.removeLast()
                groupViewModel.isCreate = false
                               }), secondaryButton: .cancel(Text("취소")))
        }
        .onAppear{
            if let user = userManager.currentUser {
                groupViewModel.user = user
            }
            groupViewModel.loadInfoGroup()
            if let member = groupViewModel.infoGroupRespose.members.first {
                groupViewModel.selectMembers = member
            }
             
            
           
        }
    }
    
}


//MARK: - UserInfoView
private struct UserInfoView: View {
    @EnvironmentObject private var groupViewModel: GroupViewModel
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 48)
                .foregroundStyle(.gray100)

            VStack(alignment: .center){
                Spacer()
                    .frame(height: 44)
                HStack {
                    Text("\(groupViewModel.selectMembers.nickname)")
                        .font(.pHeadline01)
                    Text("님의 경고 기록")
                    
                }
                Group {
                    HStack {
                        StatusRoundRectangle(iconName: "warningcountIcon", status: .warning, count: groupViewModel.selectMembers.warningCount)
                        StatusRoundRectangle(iconName: "dangercountIcon", status: .danger, count: groupViewModel.selectMembers.dangerCount)
                        
                    }
                    NotificationToggleButton()
                }
                .padding(.horizontal, 20)
               
               
                
                
                Spacer()
                    .frame(height: 200)
                
                Text("강퇴하기")
                    .underline()
                    .font(.pBody02)
                    .foregroundStyle(.gray400)
                
                
                Button {
                    groupViewModel.isLeave.toggle()
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("그룹해체하기")
                            .font(.pHeadline03)
                            .padding(.vertical, 18)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .background(.black)
                    .cornerRadius(8)
                    
                }
                .padding(.horizontal,20)
                Spacer()
                    .frame(height: 50)
            }
        }
        
       
        
    }
}

private struct NotificationToggleButton: View {
    fileprivate var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.white)
            HStack{
                Toggle("위험 발생 시 팝업", isOn: .constant(true))
                    .font(.pBody02)
                    .tint(.main)
            }
            .padding(.vertical, 33)
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - StatusRoundRectangle
private struct StatusRoundRectangle: View {
    let iconName: String
    let status: Status
    let count: Int
    fileprivate var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.white)
            HStack {
                Image(iconName)
                    
                Spacer()
                VStack(alignment: .center){
                    Text("\(count)회")
                        .font(.pHeadline03)
                        .font(.system(size: 18))
                        .foregroundStyle(.main)
                    Text(status.rawValue)
                        .font(.pHeadline02)
                }
                Spacer()
                
            }
            .padding()

        }
    }
    
}

// MARK: - profileView
private struct profileView: View {
    @EnvironmentObject private var groupViewModel: GroupViewModel
    let member: Member
    
    
    
    
    fileprivate var body: some View {
        VStack {
            AsyncImage(url: URL(string: member.profileImage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            
            .scaledToFit()
            .frame(width: 72, height: 72)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.gray500, lineWidth: 1)
            )
            .overlay {
                if member.userID == groupViewModel.selectMembers.userID {
                    ZStack{
                        Circle()
                            .foregroundStyle(.gray400.opacity(0.3))
                    }
                    Image("chek")
                    }
                }
                
            
            Text(member.nickname)
            
        }
    }
}

#Preview {
    ManagementGroupView()
}
