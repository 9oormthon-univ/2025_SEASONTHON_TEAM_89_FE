//
//  UserManager.swift
//  WatchOut
//
//  Created by 어재선 on 9/18/25.
//

import Foundation
import Combine

final class UserManager: ObservableObject {
    @Published var currentUser: User?

    static let shared = UserManager()
    
    // UserDefaults에 데이터를 저장하기 위한 고유 키
    private let userDefaultsKey = "currentUser"

    private init() {
        // ✅ 2. 앱 시작 시(UserManager가 처음 생성될 때) UserDefaults에서 사용자 정보를 불러옵니다.
        loadUserFromUserDefaults()
    }

    /// 로그인 성공 시 호출하여 현재 사용자 정보를 메모리와 UserDefaults에 저장합니다.
    func setCurrentUser(_ user: User) {
        DispatchQueue.main.async {
            self.currentUser = user
            // ✅ 1. 메모리에 저장하는 것과 동시에 UserDefaults에도 저장합니다.
            self.saveUserToUserDefaults(user)
        }
    }

    /// 로그아웃 시 호출하여 사용자 정보를 메모리와 UserDefaults에서 모두 삭제합니다.
    func clearUser() {
        DispatchQueue.main.async {
            self.currentUser = nil
            // ✅ 3. UserDefaults에서도 데이터를 삭제하여 완벽하게 로그아웃합니다.
            self.removeUserFromUserDefaults()
        }
    }
    
    // MARK: - UserDefaults Helper Methods
    
    private func saveUserToUserDefaults(_ user: User) {
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(user)
            UserDefaults.standard.set(userData, forKey: userDefaultsKey)
            print("UserDefaults에 사용자 정보 저장 완료")
        } catch {
            print("UserDefaults 저장 실패: \(error.localizedDescription)")
        }
    }
    
    private func loadUserFromUserDefaults() {
        guard let userData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        
        let decoder = JSONDecoder()
        do {
            let user = try decoder.decode(User.self, from: userData)
            self.currentUser = user
            print("UserDefaults에서 사용자 정보 로드 완료: \(user.nickname)")
        } catch {
            print("UserDefaults 디코딩 실패: \(error.localizedDescription)")
        }
    }
    
    private func removeUserFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        print("UserDefaults에서 사용자 정보 삭제 완료")
    }
}
