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
        loadUserFromUserDefaults()
    }

    func setCurrentUser(_ user: User) {
        DispatchQueue.main.async {
            self.currentUser = user
            self.saveUserToUserDefaults(user)
        }
    }

    func clearUser() {
        DispatchQueue.main.async {
            self.currentUser = nil
            self.removeUserFromUserDefaults()
        }
    }
    
    
    private func saveUserToUserDefaults(_ user: User) {
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(user)
            UserDefaults.standard.set(userData, forKey: userDefaultsKey)
            print("UserDefaults에 사용자 정보 저장 완료")
            self.loadUserFromUserDefaults()
        } catch {
            print("UserDefaults 저장 실패: \(error.localizedDescription)")
        }
    }
    
    func loadUserFromUserDefaults() {
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
