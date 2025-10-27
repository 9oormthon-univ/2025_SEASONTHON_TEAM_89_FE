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
    @Published var selectUser: String
    @Published var groupCode: String
    @Published var user: User
    @Published var selectMembers: Member = .init(
        userID: "",
        nickname: "",
        profileImage: "",
        warningCount: 0,
        dangerCount: 0,
        isCreator: false,
        joinedAt: ""
    )
    @Published var infoGroupRespose: InfoGroupRespose = .init(
        groupID: "",
        groupName: "",
        joinCode: "",
        creatorID: "",
        memberCount: 0,
        members: [],
        createdAt: ""
    )
    @Published var isCreate: Bool {
        didSet {
            SharedUserDefaults.isCreateGroup = isCreate
        }
    }
    @Published var isLeave: Bool = false
    @Published private var createGroupRespose: CreateGroupResponse?
    @Published var isJoinGroup: Bool = false
    private var service = GroupService.shared
    
    
    init(
        groupName: String = "",
        userName: String = "",
        selectUser: String = "",
        groupCode: String = "",
        isCreate: Bool = false,
        user: User = User(
            userId: "",
            kakaoId: 0,
            nickname: "",
            profileImage: ""
        )
    ) {
        self.groupName = groupName
        self.userName = userName
        self.selectUser = selectUser
        self.groupCode = groupCode
        self.isCreate = SharedUserDefaults.isCreateGroup
        self.user = user
    }
}


extension GroupViewModel {
    
    func CreateGorupAction() {
        CreateGorup()
    }
    
    func LeaveGorupAction() {
        leaveGroup()
    }
    
    func loadInfoGroup() {
        infoGroup()
    }
    
    func joinGroupAction() {
        joinGroup()
    }
    
    private func joinGroup() {
        self.service.joinGroup(joinGroup: JoinGorupRequest(joinCode: groupCode, userID: user.userId, nickname: userName.isEmpty ? user.nickname : userName ) ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_) :
                    print("joinGroup")
                    self.isCreate = true
                    self.isJoinGroup = true
                case .failure(let error):
                    print("joinGroupError\(error)")
                }
            }
            
            
            
        }
    }
    
    private func infoGroup(){
        self.service.infoGroup(userID: user.userId) { result in
            switch result {
            case .success(let response):
                self.infoGroupRespose = response
                //                self.members = response.members
                self.infoGroupRespose.members = self.infoGroupRespose.members.sorted {
                    ($0.userID == self.user.userId) && ($1.userID != self.user.userId)
                }
                if let member = self.infoGroupRespose.members.first {
                    self.selectMembers = member
                }
                print("\(self.infoGroupRespose.members)")
                
            case .failure(let error):
                SharedUserDefaults.isCreateGroup = false
                print("onfoGroupError\(error)")
            }
            
        }
        
    }
    
    private func leaveGroup() {
        self.service.leaveGrou(userID: user.userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_) :
                    print("leveGroupSuccess")
                case .failure(let error):
                    print("leveGroupError\(error)")
                }
            }
            
        }
    }
    
    
    private func CreateGorup() {
        
        if(!groupName.isEmpty) {
            self.service.CreateGroup(groupRequest: CreateGroupRequest(userID: user.userId , groupName: groupName, nickname: userName.isEmpty ? user.nickname: userName)) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let respose):
                        self?.isCreate = true
                        self?.createGroupRespose = respose
                        self?.groupName = ""
                    case .failure(let error):
                        print("CreateGroupError:\(error)")
                    }
                }
                
            }
            
        }
    }
}
