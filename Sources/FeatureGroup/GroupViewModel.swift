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
    @Published var selectMembers: GroupMember = .init(
        id: "",
        nickname: "",
        profileImage: "",
        warningCount: 0,
        dangerCount: 0,
        isCreator: false,
        notificationEnabled: true
    )
    @Published var groupInfo: FamilyGroup?
    @Published var isCreate: Bool {
        didSet {
            SharedUserDefaults.isCreateGroup = isCreate
        }
    }
    @Published var isLeave: Bool = false
    @Published var isJoinGroup: Bool = false

    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isLoading: Bool = false

    private let repository: GroupRepository
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
        ),
        repository: GroupRepository = GroupRepositoryImpl()
    ) {
        self.groupName = groupName
        self.userName = userName
        self.selectUser = selectUser
        self.groupCode = groupCode
        self.isCreate = SharedUserDefaults.isCreateGroup
        self.repository = repository
        if let savedUser = userManager.currentUser {
            self.user = savedUser
            Log.debug("저장된 유저 소환: \(savedUser.nickname)")
        } else {
            self.user = user
            Log.debug("저장된 유저 없음")
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
            .map { userName in
                if userName.isEmpty {
                    self.isValidUserName = true
                    return ""
                } else if userName.count > 6 {
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
                    Task { await self.verifyGroupCode() }
                    return ""
                } else {
                    self.isValidGroupCode = false
                    return "존재하지 않는 코드입니다"
                }
            }
            .assign(to: &$groupCodeMessage)

        Publishers.CombineLatest($isValidUserName, $isValidGroupCode)
            .map { valid1, valid2 in
                valid1 && valid2
            }
            .assign(to: &$isJoinButtonEnabled)

        Publishers.CombineLatest($isValidGroupName, $isValidUserName)
            .map { valid1, valid2 in
                valid1 && valid2
            }
            .assign(to: &$isCreateButtonEnabled)
    }
}

extension GroupViewModel {

    func countMembers() -> Int {
        groupInfo?.members.count ?? 0
    }

    func createGroupAction() {
        Task { await createGroup() }
    }

    func leaveGroupAction() {
        Task { await leaveGroup() }
    }

    func loadInfoGroup() {
        Task { await fetchGroupInfo() }
    }

    func joinGroupAction() {
        Task { await joinGroup() }
    }

    func startPolling() {
        Task { @MainActor in
            await fetchGroupInfo()
            if let member = groupInfo?.members.first {
                selectMembers = member
            }
        }

        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task { await self?.fetchGroupInfo() }
        }
    }

    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }

    @MainActor
    private func joinGroup() async {
        do {
            try await repository.joinGroup(
                code: groupCode,
                userId: user.userId,
                nickname: userName.isEmpty ? user.nickname : userName
            )
            Log.debug("joinGroup 성공")
            isCreate = true
            isJoinGroup = true
            showError = false
        } catch {
            Log.error("joinGroup 실패: \(error)")
            handleError(error)
        }
    }

    @MainActor
    private func verifyGroupCode() async {
        isValidGroupCodeLoding = true
        defer { isValidGroupCodeLoding = false }
        do {
            isValidGroupCode = try await repository.verifyJoinCode(groupCode)
            groupCodeMessage = isValidGroupCode ? "존재하는 코드입니다." : "존재하지 않는 코드입니다"
        } catch {
            Log.error("verifyGroupCode 실패: \(error)")
            isValidGroupCode = false
            groupCodeMessage = "존재하지 않는 코드입니다"
        }
    }

    @MainActor
    private func fetchGroupInfo() async {
        if groupInfo == nil {
            isLoading = true
        }
        do {
            var info = try await repository.fetchGroupInfo(userId: user.userId)
            info.members.sort {
                ($0.id == user.userId) && ($1.id != user.userId)
            }
            groupInfo = info
            isLoading = false
            Log.debug("infoGroup 성공: 멤버 \(info.members.count)명")
        } catch {
            isLoading = false
            SharedUserDefaults.isCreateGroup = false
            Log.error("infoGroup 실패: \(error)")
            handleError(error)
        }
    }

    @MainActor
    private func leaveGroup() async {
        do {
            try await repository.leaveGroup(userId: user.userId)
            Log.debug("leaveGroup 성공")
            isCreate = false
            stopPolling()
            SharedUserDefaults.isCreateGroup = false
        } catch {
            Log.error("leaveGroup 실패: \(error)")
            handleError(error)
        }
    }

    @MainActor
    private func createGroup() async {
        guard !groupName.isEmpty else { return }
        do {
            _ = try await repository.createGroup(
                userId: user.userId,
                groupName: groupName,
                nickname: userName.isEmpty ? user.nickname : userName
            )
            Log.debug("createGroup 성공")
            isCreate = true
            groupName = ""
        } catch {
            Log.error("createGroup 실패: \(error)")
            handleError(error)
        }
    }

    // MARK: - Error Handling
    private func handleError(_ error: Error) {
        let apiError = error as? APIError ?? .unknown(statusCode: -1, message: error.localizedDescription)

        errorMessage = apiError.message
        showError = true

        switch apiError {
        case .validationError:
            errorMessage = apiError.validationMessages.joined(separator: "\n")
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
