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
                HStack(alignment: .bottom) {
                    VStack {
                        
                        Text("총 명")
                            .font(.gHeadline01)
                    }
                    Spacer()
                    
                }
                .padding(.leading, 20)
                HStack {
                    Text("그룹 참여 코드")
                        .font(.pSubtitle03)
                        .foregroundStyle(.gray300)
                    Spacer()
                    Text("1KEUS334SJ")
                    Button {
                        
                    } label: {
                        Image("CopyIcon")
                    }
                    
                }
                .padding(.horizontal,20)
                Spacer()
                    .frame(height: 20)
                ScrollView(.horizontal){
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        
                        if let user = userManager.currentUser {
                            profileView(user: user)
                                .onTapGesture {
                                    groupViewModel.selectUser = user.userId
                                }
                                
                                    
                        }
                    }
                    Spacer()
                }
                
                UserInfoView(user: userManager.currentUser!)
            }
        }
        .onAppear{
//            if let user = userManager.currentUser {
//                groupViewModel.selectUser = user.userId
//            }
        }
    }
    
}


//MARK: - UserInfoView
private struct UserInfoView: View {
    let user: User
    
    fileprivate var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 48)
                .foregroundStyle(.gray100)

            VStack(alignment: .center){
                Spacer()
                    .frame(height: 44)
                HStack {
                    Text("\(user.nickname)")
                        .font(.pHeadline01)
                    Text("님의 경고 기록")
                    
                }
                Group {
                    HStack {
                        StatusRoundRectangle(iconName: "warningcountIcon", status: .warning, count: 10)
                        StatusRoundRectangle(iconName: "dangercountIcon", status: .danger, count: 20)
                        
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
            }.padding()
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
    let user: User
    
    
    
    
    fileprivate var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.profileImage)) { image in
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
                if user.userId == groupViewModel.selectUser {
                    ZStack{
                        Circle()
                            .foregroundStyle(.gray400.opacity(0.3))
                    }
                    Image("chek")
                    }
                }
                
            
            Text(user.nickname)
            
        }
    }
}

#Preview {
    ManagementGroupView()
}
