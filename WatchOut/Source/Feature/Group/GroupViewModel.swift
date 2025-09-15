//
//  GroupViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation

class GroupViewModel: ObservableObject {
    @Published var groupName: String
    @Published var userName: String
    @Published var GroupCode: String
    let groupService = GroupService()
    init(groupName: String = "", userName: String = "", GroupCode: String = "") {
        self.groupName = groupName
        self.userName = userName
        self.GroupCode = GroupCode
    }
}

extension GroupViewModel{
    func create() async -> Bool {
        print("🟡 [GroupViewModel] create() 함수 시작")
        print("🟡 [GroupViewModel] 입력값 - 그룹명: '\(groupName)', 사용자명: '\(userName)'")
        print("🟡 [GroupViewModel] userID: \(SharedUserDefaults.userID)")
        
        do {
            print("🟡 [GroupViewModel] groupService.createGroup() 호출 시작")
            let result = try await groupService.createGroup(groupName: groupName, userID: SharedUserDefaults.userID, userName: userName)
            print("🟢 [GroupViewModel] groupService.createGroup() 성공!")
            print("🟡 [GroupViewModel] 결과 - groupID: \(result.groupID), joinCode: \(result.joinCode)")
            
            SharedUserDefaults.groupCode = result.groupID
            SharedUserDefaults.joinId = result.joinCode
            print("🟡 [GroupViewModel] SharedUserDefaults 저장 완료")
            return true
        } catch {
            print("🔴 [GroupViewModel] groupService.createGroup() 실패!")
            print("🔴 [GroupViewModel] 에러: \(error)")
            return false
        }
    }
}
