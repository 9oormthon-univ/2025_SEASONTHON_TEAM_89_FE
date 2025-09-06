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
        do {
            let result = try await groupService.createGroup(groupName: groupName, userID: SharedUserDefaults.userID, userName: userName)
            SharedUserDefaults.groupCode = result.groupID
            SharedUserDefaults.joinId = result.joinCode
            return true
        } catch {
            return false
        }
        
       
    }
}
