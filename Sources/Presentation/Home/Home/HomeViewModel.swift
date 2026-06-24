//
//  HomeViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 11/9/25.
//

import Foundation
import Domain
import Platform

class HomeViewModel: ObservableObject {
    @Published var risk2Count: Int = 0
    @Published var risk3Count: Int = 0
    @Published var username:String = "위허메"
    // 첫 렌더는 캐시값으로(깜빡임 방지), 이후 syncGroupMembership()이 서버 기준으로 보정한다.
    @Published var isInGroup: Bool = SharedUserDefaults.isCreateGroup

    private let userManager: UserManager
    private let groupRepository: GroupRepository

    init(userManager: UserManager, groupRepository: GroupRepository) {
        self.userManager = userManager
        self.groupRepository = groupRepository
        userManager.loadUserFromUserDefaults()
    }

    func loadData() {
        userManager.loadUserFromUserDefaults()

        if let username = userManager.currentUser?.nickname {
            self.username = username
        }

        risk2Count = SharedUserDefaults.riskLevel2Count
        risk3Count = SharedUserDefaults.riskLevel3Count
    }

    /// 앱/홈 진입 시 서버를 기준으로 그룹 소속 여부를 동기화한다.
    /// 로컬 플래그(isCreateGroup)만 믿지 않고 실제 멤버십을 확인해 desync를 방지.
    @MainActor
    func syncGroupMembership() async {
        guard let userId = userManager.currentUser?.userId, !userId.isEmpty else { return }
        do {
            _ = try await groupRepository.fetchGroupInfo(userId: userId)
            isInGroup = true
            SharedUserDefaults.isCreateGroup = true
        } catch {
            // 그룹이 실제로 없을 때(404)만 false로. 네트워크/서버 일시 오류는 기존 상태 유지.
            if case .notFound = (error as? APIError) {
                isInGroup = false
                SharedUserDefaults.isCreateGroup = false
            }
            Log.error("syncGroupMembership 실패: \(error)")
        }
    }

}
