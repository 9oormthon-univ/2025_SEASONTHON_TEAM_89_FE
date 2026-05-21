//
//  GroupViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/7/25.
//

import Foundation
import Combine
import Domain
import Core
import Data

class GroupViewModel: ObservableObject {
    
    @Published var groupName: String
    @Published var groupNameMessage: String = ""
    @Published var isValidGroupName: Bool = false
    
    @Published var userName: String
    @Published var userNameMessage: String = ""
    @Published var isValidUserName: Bool = false
    
    @Published var selectUser: String
    @Published var groupCode: String
    @Published var groupCodeMessage: String = ""
    @Published var isValidGroupCode: Bool = false
    @Published var isValidGroupCodeLoding: Bool = false
    
    @Published var isCreateButtonEnabled: Bool = false
    @Published var isJoinButtonEnabled: Bool = false
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
    @Published var infoGroupResponse: InfoGroupResponse?
    @Published var isCreate: Bool {
        didSet {
            SharedUserDefaults.isCreateGroup = isCreate
        }
    }
    @Published var isLeave: Bool = false
    @Published private var createGroupResponse: CreateGroupResponse?
    @Published var isJoinGroup: Bool = false
    
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isLoading: Bool = false
    private var service = GroupService.shared
    private var userManager = UserManager.shared
    private var timer: Timer?
    
    private var cancellables = Set<AnyCancellable>()
    
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
        $groupName
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { groupName in
                if groupName.isEmpty {
                    self.isValidGroupName = false
                    return ""
                } else if groupName.count > 8 {
                    self.isValidGroupName = false
                    return "최대 8글자 입력 가능합니다"
                } else {
                    self.isValidGroupName = true
                    return ""
                }
            }
            .assign(to: &$groupNameMessage)
        
        $userName
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { groupName in
                if groupName.isEmpty {
                    self.isValidUserName = true
                    return ""
                } else if groupName.count > 6 {
                    self.isValidUserName = false
                    return "최대 6글자 입력 가능합니다"
                } else {
                    self.isValidUserName = true
                    return ""
                }
            }
            .assign(to: &$userNameMessage)
        
        $groupCode
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { groupCode in
                if groupCode.isEmpty {
                    return ""
                } else if groupCode.count == 10 {
                    self.verifyGroupCode() { [weak self] in
                        guard let self = self else { return }
                        if self.isValidGroupCode {
                            groupCodeMessage = "존재하는 코드입니다."
                        } else {
                            self.isValidGroupCode = false
                            groupCodeMessage = "존재하지 않는 코드입니다"
                        }
                    }
                    return ""
                } else {
                    self.isValidGroupCode = false
                    return "존재하지 않는 코드입니다"
                }
            }
            .assign(to: &$groupCodeMessage)
        
        Publishers.CombineLatest($isValidUserName, $isValidGroupCode)
            .map{ valid1, valid2 in
                    return valid1 && valid2
            }
            .assign(to: &$isJoinButtonEnabled)
        
        Publishers.CombineLatest($isValidGroupName, $isValidUserName)
            .map{ valid1, valid2 in
                return valid1 && valid2
            }
            .assign(to: &$isCreateButtonEnabled)
    }
    
    
    
}


extension GroupViewModel {
    
    
    
    func countMembers() -> Int {
        guard let infoGroup = self.infoGroupResponse else { return 0}
        
        return infoGroup.memberCount
    }
    
    func CreateGroupAction() {
        CreateGroup()
    }
    
    func LeaveGroupAction() {
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
            
            if let member = self.infoGroupResponse?.members.first {
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
            joinGroup: JoinGroupRequest(
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
    
    private func verifyGroupCode(completion: (() -> Void)? = nil) {
        isValidGroupCodeLoding = true
        self.service.verifyGroupCode(groupCode: VerifyRequest(joinCode: groupCode)) { [weak self] result in
            guard let self = self else { return }
            isValidGroupCodeLoding = false
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.isValidGroupCode = response.isValid
                    completion?()
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    private func infoGroup(completion: (() -> Void)? = nil) {
        if infoGroupResponse == nil {
            self.isLoading = true
        }
        self.service.infoGroup(userID: user.userId) { [weak self] result in
            guard let self = self else { return }
            
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.infoGroupResponse = response
                    
                    self.infoGroupResponse?.members = self.infoGroupResponse?.members.sorted {
                        ($0.userID == self.user.userId) && ($1.userID != self.user.userId)
                    } ?? []
                    completion?()
                    print("✅ infoGroup 성공: \(String(describing: self.infoGroupResponse?.members))")
                    
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
    
    private func CreateGroup() {
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
                    self.createGroupResponse = response
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
