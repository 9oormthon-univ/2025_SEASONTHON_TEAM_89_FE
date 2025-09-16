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
    init(groupName: String = "", userName: String = "", GroupCode: String = "") {
        self.groupName = groupName
        self.userName = userName
        self.GroupCode = GroupCode
    }
}
