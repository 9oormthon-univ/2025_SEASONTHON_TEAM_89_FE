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
    @Published var isCreate: Bool
    @Published private var createGroupRespose: CreateGroupResponse?
    private var service = GroupService.shared
    
    
    init(groupName: String = "", userName: String = "", GroupCode: String = "", isCreate: Bool = false) {
        self.groupName = groupName
        self.userName = userName
        self.GroupCode = GroupCode
        self.isCreate = isCreate
    }
}


extension GroupViewModel {
    
    func CreateGorupAction() {
        CreateGorup()
    }
    
    
    private func CreateGorup() {
        
        if(!groupName.isEmpty && !userName.isEmpty) {
            self.service.CreateOroup(groupRequest: CreateGroupRequest(groupName: groupName, userID: SharedUserDefaults.userID, userName: userName)) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let respose):
                        self?.isCreate = true
                        self?.createGroupRespose = respose
                    case .failure(let error):
                        print("CreateGroupError:\(error)")
                    }
                }
                
            }
            
        }
    }
}
