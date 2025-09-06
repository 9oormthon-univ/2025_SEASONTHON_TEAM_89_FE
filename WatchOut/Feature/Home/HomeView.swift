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
            // 타이틀
            TitleView()
                .padding(.horizontal, 20)
           
            // 체험하기로 이동
            ExprienceButton()
                .padding(.horizontal, 20)
            Spacer()
                .frame(height: 36)
            
            HStack(spacing: 8) {
                StatusRoundRectangle(status: .warning, count: 24)
                StatusRoundRectangle(status: .danger, count: 3)
            } .padding(.horizontal, 20)
            Spacer()
                .frame(height: 16)
            GroupTitleView()
                .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: 16)
            HStack {
                GroupBoxRowView(title: "그룹 만들기", imageName: "maingroup1")
                    .onTapGesture {
                        pathModel.paths.append(.createGroupView)
                    }
                Spacer()
                GroupBoxRowView(title: "그룹 입장하기", imageName: "maingroup2")
                    .onTapGesture {
                        pathModel.paths.append(.joinGroupView)
                    }
                Spacer()
                GroupBoxRowView(title: "내 그릅 관리", imageName: "maingroup3")
                    .onTapGesture {
                        pathModel.paths.append(.managementGroupView)
                    }
            }
            .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: 36)
            ExperienceListView()
                .padding(.horizontal,20)
            CustomDivider()
                .frame(maxWidth: .infinity)
            
            DetailSettingListView()
                .padding(.horizontal,20)
            CustomDivider()
            Spacer()
            ReportListView()
                .padding(.horizontal,20)
            
            
        }
        
       
    }
}

//MARK: - TitleView
private struct TitleView: View {
    fileprivate var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text("위허메 키보드에")
                    .font(.gHeadline01)
                HStack{
                    Text("오신걸 환영해요")
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
    let status: Status
    let count: Int
    fileprivate var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                
                Image("star")
                    .foregroundStyle(status == .warning ? .main : .red)
                HStack{
                    Text(status.rawValue)
                        .font(.pHeadline02)
                    Text("\(count)회")
                        .font(.pHeadline03)
                        .font(.system(size: 18))
                        .foregroundStyle(.main)
                }
                Spacer()
                    .frame(height: 14)
                Text("자세히 보기")
                    .font(.pCaption01)
                    .foregroundStyle(.gray400)
            }
            .padding()
            Spacer()
                
            }
        .overlay {
            RoundedRectangle(cornerRadius: 21)
                .stroke(Color.gray200, lineWidth: 1)
        }
    }
}


// MARK: - GroupTitleView
private struct GroupTitleView: View  {
    fileprivate var body: some View {
        HStack {
            Text("가족과 함께 사용해 보세요!")
                .font(.pHeadline02)
            Spacer()
        }
    }
}

// MARK: - GroupBoxRowView
private struct GroupBoxRowView: View {
    let title: String
    let imageName: String
    fileprivate var body: some View {
        VStack(alignment: .center) {
            Image(imageName)
              
            Text(title)
                .font(.pBody02)
        }
        .frame(width: 120,height: 120)
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(.gray300, lineWidth: 1)
        }
        
        
    }
}

// MARK: - subTitleView
private struct SubTitleView: View {
    let title: String
    fileprivate var body: some View {
        HStack {
            Text(title)
                .font(.pHeadline03)
                .foregroundStyle(.main)
            Spacer()
        }
    }
}

// MARK: - ListRowView
private struct ListRowView: View {
    let title: String
    let description: String
    let imageName: String
    fileprivate var body: some View {
        HStack{
            Image(imageName)
            VStack(alignment: .leading){
                Text(title)
                    .font(.pBody02)
                    .foregroundStyle(.black)
                Text(description)
                    .font(.pCaption01)
                    .foregroundStyle(.gray400)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.black)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - ExperienceListView
private struct ExperienceListView: View {
    fileprivate var body: some View {
        VStack {
            SubTitleView(title: "체험 하기")
            ListRowView(
                title: "위험 문장 감지",
                description: "금융사기 관련 위험 문장을 빠르게 감지해요!", imageName: "mainimage1"
            )
            ListRowView(title: "위험도 시각화 + 경고 진동", description: "문장의 위험도가 색상으로 표시되고 진동과 팝업으로 경고가 떠요!", imageName: "mainimage2")
            ListRowView(title: "신고 연결", description: "리딩방, 수익보장형 사기 등 다양한 금융범죄 유형에 맞춰 맞춤 경고를 제공해요!", imageName: "mainimage3")
        }
    }
    
}

// MARK: - DetailSettingListView
private struct DetailSettingListView: View {
    fileprivate var body: some View {
        VStack {
            SubTitleView(title: "상세 설정")
            ListRowView(title: "키보드 커스텀", description: "키보드에 표시되는 경고 신호 색상을 취향껏 꾸며봐요! ", imageName: "mainimage4")
            ListRowView(title: "팝업 및 진동", description: "팝업과 진동의 유뮤를 설정해요", imageName: "mainimage5")
        }
    }
}
// MARK: - ReportListView
private struct ReportListView: View {
    fileprivate var body: some View {
        VStack {
            SubTitleView(title: "신고하기")
            ListRowView(title: "신고 전화번호", description: "리딩방, 수익보장형 사기 등 다양한 금융범죄 유형에 맞춰 맞춤 경고를 제공해요!", imageName: "mainimage6")
        }
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
