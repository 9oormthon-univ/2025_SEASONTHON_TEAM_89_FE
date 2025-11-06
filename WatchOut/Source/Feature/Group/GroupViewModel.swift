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
        joinedAt: "",
        notificationEnabled: true
    )
    @Published var infoGroupRespose: InfoGroupRespose?
    @Published var isCreate: Bool {
        didSet {
            SharedUserDefaults.isCreateGroup = isCreate
        }
    }
    @Published var isLeave: Bool = false
    @Published private var createGroupRespose: CreateGroupResponse?
    @Published var isJoinGroup: Bool = false
    
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isLoading: Bool = false
    private var service = GroupService.shared
    private var userManager = UserManager.shared
    private var timer: Timer?
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
        if let user = userManager.currentUser{
            self.user = user
            print("저장된 유저 소환\(user)")
        } else {
            self.user = user
            print("저장된 유저 없음\(user)")
        }
        
    }
    
    
}


extension GroupViewModel {
    func countMembers() -> Int {
        guard let infoGroup = self.infoGroupRespose else { return 0}
        
        return infoGroup.memberCount
    }
    
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
    
    func startPolling() {
        infoGroup { [weak self] in
            guard let self = self else { return }
            
            if let member = self.infoGroupRespose?.members.first {
                self.selectMembers = member
            }
            
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.infoGroup()
        }
    }
    
    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }
    
    
    private func joinGroup() {
        self.service.joinGroup(
            joinGroup: JoinGorupRequest(
                joinCode: groupCode,
                userID: user.userId,
                nickname: userName.isEmpty ? user.nickname : userName
            )
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success:
                    print("✅ joinGroup 성공")
                    self.isCreate = true
                    self.isJoinGroup = true
                    self.showError = false
                case .failure(let error):
                    print("❌ joinGroup 실패: \(error.message)")
                    self.handleError(error)
                }
            }
        }
    }
    
    private func infoGroup(completion: (() -> Void)? = nil) {
        if infoGroupRespose == nil {
            self.isLoading = true
        }
        self.service.infoGroup(userID: user.userId) { [weak self] result in
            guard let self = self else { return }
            
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.infoGroupRespose = response
                    
                    self.infoGroupRespose?.members = self.infoGroupRespose?.members.sorted {
                        ($0.userID == self.user.userId) && ($1.userID != self.user.userId)
                    } ?? []
                    completion?()
                    print("✅ infoGroup 성공: \(String(describing: self.infoGroupRespose?.members))")
                    
                case .failure(let error):
                    SharedUserDefaults.isCreateGroup = false
                    print("❌ infoGroup 실패: \(error.message)")
                    self.handleError(error)
                }
            }
            
        }
    }
    
    private func leaveGroup() {
        self.service.leaveGroup(userID: user.userId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success:
                    print("✅ leaveGroup 성공")
                    self.isCreate = false
                    self.stopPolling()
                    SharedUserDefaults.isCreateGroup = false

                    
                case .failure(let error):
                    print("❌ leaveGroup 실패: \(error.message)")
                    self.handleError(error)
                }
            }
        }
    }
    
    private func CreateGorup() {
        guard !groupName.isEmpty else {
            
            return
        }
        
        self.service.createGroup(
            groupRequest: CreateGroupRequest(
                userID: user.userId,
                groupName: groupName,
                nickname: userName.isEmpty ? user.nickname : userName
            )
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    print("✅ CreateGroup 성공")
                    self.isCreate = true
                    self.createGroupRespose = response
                    self.groupName = ""
                    
                case .failure(let error):
                    print("❌ CreateGroup 실패: \(error.message)")
                    self.handleError(error)
                }
            }
        }
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: APIError) {
        // 공통 에러 처리
        errorMessage = error.message
        showError = true
        
        switch error {
        case .validationError(let errors):
            print("📝 검증 오류:")
            for detail in errors {
                let field = detail.loc.last?.value ?? "unknown"
                print("  - \(field): \(detail.msg)")
            }
            errorMessage = error.validationMessages.joined(separator: "\n")
            stopPolling()
           
        case .unauthorized:
            stopPolling()
           
        case .networkError:
            break
        case .serverError:
            
            errorMessage = "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
            stopPolling()
            
        default:
            break
        }
    }
}
