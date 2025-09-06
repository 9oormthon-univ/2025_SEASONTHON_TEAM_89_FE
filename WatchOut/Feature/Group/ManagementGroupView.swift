//
//  ManagementGroupView.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import SwiftUI

struct ManagementGroupView: View {
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                VStack {
                    
                    Text("나의 그룹")
                        .font(.gHeadline01)
                }
                Spacer()
                Image("WaitingGroup")
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
                .frame(height: 40)
            VStack{
                
                HStack {
                    Text("총 3명")
                        .font(.pHeadline01)
                    Spacer()
                }
                HStack {
                    Text( "참여자가 다 모이면 완성하기 버튼을 눌러주세요!")
                        .foregroundStyle(.gray400)
                        .font(.pSubtitle03)
                    Spacer()
                }
                Spacer()
                    .frame(height: 20)
               GroupRowView()
                
                Spacer()
                
                Button {
                    
            
                    
                } label: {
                    Spacer()
                    Text("만들기")
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
            .ignoresSafeArea()
            
        }
    }
}


//MARK: - GroupRowView
private struct GroupRowView: View {
    fileprivate var body: some View {
        HStack {
            Text("조강미")
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.black)
            }
        }
        .padding()
        
        .background(.white)
        .cornerRadius(50)
        .overlay {
            RoundedRectangle(cornerRadius: 50)
                .stroke(.gray300,lineWidth: 1)
        }
    }
}

#Preview {
    ManagementGroupView()
}
