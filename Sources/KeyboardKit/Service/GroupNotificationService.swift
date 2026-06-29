//
//  GroupNotificationService.swift
//  WatchOutkeyboard
//
//  위험/경고 감지 시 서버에 카운트를 업데이트하고, 서버가 그룹원에게 자동 푸시를 보낸다.
//  - PUT /api/notifications/danger-count   { user_id, danger_count }
//  - PUT /api/notifications/warning-count  { user_id, warning_count }
//  키보드 익스텐션(Full Access)에서 호출. user_id는 App Group(SharedUserDefaults)에서 읽는다.
//

import Foundation

public struct GroupNotificationService {

    public static let shared = GroupNotificationService()

    private let baseURL = "https://wiheome.ajb.kr/api"

    private init() {}

    /// 위험(danger) 카운트 업데이트 + 그룹 자동 푸시.
    public func reportDangerCount(userId: String, count: Int) {
        send(path: "/notifications/danger-count", body: ["user_id": userId, "danger_count": count])
    }

    /// 경고(caution) 카운트 업데이트 + 그룹 자동 푸시.
    public func reportWarningCount(userId: String, count: Int) {
        send(path: "/notifications/warning-count", body: ["user_id": userId, "warning_count": count])
    }

    private func send(path: String, body: [String: Any]) {
        // user_id가 비면 서버가 식별 불가 → 호출하지 않음.
        if let uid = body["user_id"] as? String, uid.isEmpty {
            print("[GroupNotify] user_id 비어있음 → 전송 생략")
            return
        }
        guard let url = URL(string: baseURL + path),
              let data = try? JSONSerialization.data(withJSONObject: body) else {
            print("[GroupNotify] 요청 생성 실패: \(path)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("[GroupNotify] 전송 실패 \(path): \(error.localizedDescription)")
                return
            }
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            print("[GroupNotify] \(path) → \(code)")
        }.resume()
    }
}
