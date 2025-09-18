//
//  GroupViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation

class GroupViewModel: ObservableObject {
    
    @Published var groupName: String
    @Published var selectUser: String
    @Published var GroupCode: String
    @Published var user: User
    @Published var isCreate: Bool {
        didSet {
            SharedUserDefaults.isCreateGroup = isCreate
        }
    }
    @Published private var createGroupRespose: CreateGroupResponse?
    private var service = GroupService.shared
    
    
    init(groupName: String = "", selectUser: String = "", GroupCode: String = "", isCreate: Bool = false, user: User = User(userId: "", kakaoId: 0, nickname: "", profileImage: "")) {
        self.groupName = groupName
        self.selectUser = selectUser
        self.GroupCode = GroupCode
        self.isCreate = SharedUserDefaults.isCreateGroup
        self.user = UserManager.shared.currentUser!
    }
}


extension GroupViewModel {
    
    func CreateGorupAction() {
        CreateGorup()
    }
    
    
    private func CreateGorup() {
        
        if(!groupName.isEmpty) {
            self.service.CreateGroup(groupRequest: CreateGroupRequest(userID: user.userId , nickname: user.nickname)) { [weak self] result in
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
