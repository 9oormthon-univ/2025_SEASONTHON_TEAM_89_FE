//
//  HomeView.swift
//  WatchOut
//
//  Created by 어재선 on 9/4/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    var body: some View {
        ScrollView(showsIndicators: false){
            Spacer()
                .frame(height: 20)
            TitleView()
                .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: 34)
            
            HStack(spacing: 8) {
                StatusRoundRectangle(iconName: "warningcountIcon", status: .warning, count: SharedUserDefaults.riskLevel2Count)
                StatusRoundRectangle(iconName: "dangercountIcon1", status: .danger, count: SharedUserDefaults.riskLevel3Count)
            } .padding(.horizontal, 20)
            Spacer()
                .frame(height: 34)
            CustomDivider()
            Spacer()
                .frame(height: 34)
            GroupTitleView()
                .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: 16)
            VStack(spacing: 8) {
                
                if SharedUserDefaults.isCreateGroup {
                    GroupBoxRowView(title: "내 그룹 관리", subTitle: "가족 그룹을 관리해 보세요", imageName: "maingroup3")
                        .onTapGesture {
                            pathModel.paths.append(.managementGroupView)
                        }
                } else {
                    GroupBoxRowView(title: "그룹 만들기", subTitle: "가족과 함께 지켜봐요", imageName: "person-add")
                        .onTapGesture {
                            pathModel.paths.append(.createGroupView)
                        }
                    
                    GroupBoxRowView(title: "그룹 입장하기", subTitle: "가족이 만든 그룹에 입장해 보세요", imageName: "login")
                        .onTapGesture {
                            pathModel.paths.append(.joinGroupView)
                        }
                }
            }
            Spacer()
                .frame(height: 34)
            CustomDivider()
            Spacer()
                .frame(height: 34)
            SubTitleView(title: "플러스 플랜을 체험해봐요", subTtile: "더 나은 예방을 위해")
                .padding(.horizontal, 20)
            ExperienceListView()
            Spacer()
                .frame(height: 16)
            ExprienceButton()
                .padding(.horizontal, 20)
        }
        .onAppear {
            UserManager.shared.loadUserFromUserDefaults()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationManager.instance.requestAuthorization()
            }
        }
    }
}


//MARK: - TitleView
private struct TitleView: View {
    
    fileprivate var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 20)
                HStack{
                    Text("\(UserManager.shared.currentUser?.nickname ?? "위허메")님 환영해요")
                        .font(.gHeadline01)
                    
                    Image("star")
                        .foregroundStyle(.main)
                    
                    
                }.offset(y: -15)
            }
            Spacer()
        }
        HStack {
            Text("위허메와 함께 금융 범죄를 예방해요!")
                .font(.pBody01)
                .foregroundStyle(.gray500)
                .offset(y: -15)
            Spacer()
        }
    }
}


//MARK: - ExperienceButton
private struct ExprienceButton: View {
    @EnvironmentObject private var pathModel: PathModel
    fileprivate var body: some View {
        Image("tryitbutton")
            .onTapGesture {
                pathModel.paths.append(.exprienceView)
            }
    }
}

// MARK: - StatusRoundRectangle
private struct StatusRoundRectangle: View {
    let iconName: String
    let status: Status
    let count: Int
    fileprivate var body: some View {
        VStack {
            
            HStack {
                Spacer()
                VStack{
                    Image(iconName)
                    Spacer()
                }
                VStack(alignment: .leading){
                    Spacer()
                        .frame(height: 30)
                    Text(status.rawValue)
                        .font(.pBody01)
                    Text("총 \(count)회")
                        .font(.pHeadline01)
                        .font(.system(size: 18))
                        .foregroundStyle(.main)
                    
                }
                Spacer()
            }
            .padding(.vertical,14)
            .padding(.horizontal,20)
            
        }
        .background(status == .warning ? .main.opacity(0.08) : .risk1Color1.opacity(0.08))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(status == .warning ? .main : .risk1Color1, lineWidth: 1)
        }
    }
    
}


// MARK: - GroupTitleView
private struct GroupTitleView: View  {
    fileprivate var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("그룹 생성 및 참가")
                    .font(.pHeadline03)
                    .foregroundStyle(.main)
                Text("가족과 함께 사용해 보세요!")
                    .font(.pHeadline01)
                Spacer()
            }
            Spacer()
        }
        
    }
}

// MARK: - GroupBoxRowView
private struct GroupBoxRowView: View {
    let title: String
    let subTitle: String
    let imageName: String
    fileprivate var body: some View {
        HStack {
            Image(imageName)
                .padding(8)
                .background(.gray100.opacity(0.5))
                .cornerRadius(12, corners: .allCorners)
            VStack(alignment: .leading){
                Text(title)
                    .font(.pBody01)
                Text(subTitle)
                    .font(.pCaption01)
                    .foregroundStyle(.gray400)
            }
            Spacer()
            Image("chevron-right-small")
        }
        .padding(.vertical,10)
        .padding(.horizontal,20)
        
    }
}

// MARK: - subTitleView
private struct SubTitleView: View {
    let title: String
    let subTtile: String
    fileprivate var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(subTtile)
                    .font(.pHeadline03)
                    .foregroundStyle(.main)
                Text(title)
                    .font(.pHeadline01)
            }
            Spacer()
        }
    }
}

// MARK: - ListRowView
private struct ListRowView: View {
    let title: String
    let imageName: String
    fileprivate var body: some View {
        HStack{
            Spacer()
            VStack(alignment: .center){
                Spacer()
                Image(imageName)
                    .padding(.top,16)
                Text(title)
                    .font(.pBody02)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                Spacer()
            }
            Spacer()
        }
        .background(.gray100.opacity(0.5))
        .cornerRadius(16, corners: .allCorners)
    }
}

// MARK: - ExperienceListView
private struct ExperienceListView: View {
    fileprivate var body: some View {
        HStack {
            let columns: [GridItem] = [
                GridItem(.adaptive(minimum: 114), spacing:10)
            ]
            LazyVGrid(columns:columns,alignment: .center) {
                ListRowView(
                    title: "위험 문장 감지 가능",imageName: "alert-triangle"
                )
                
                ListRowView(title: "위험도 시각화 가능", imageName: "siren")
                
                ListRowView(title: "가족 그룹 생성 가능", imageName: "person-add")
            }
        }
        .padding(.horizontal,20)
    }
    
}

// MARK: - CustomDivider
private struct CustomDivider: View {
    fileprivate var body: some View {
        Rectangle()
            .frame(height: 8)
            .foregroundStyle(.gray100)
    }
}


#Preview {
    HomeView()
}
