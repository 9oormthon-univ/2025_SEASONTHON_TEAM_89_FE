//
//  GroupNotificationService.swift
//  WatchOutkeyboard
//
//  키보드에서 감지한 위험/경고를 서버에 반영한다.
//  - 카운트(그룹 화면 숫자): PUT /api/notifications/{danger,warning}-count  — 푸시 없음, 카운트만
//  - 그룹 푸시(위험 시): POST /api/notifications/danger                     — 그룹원에게 푸시
//  키보드 익스텐션(Full Access)에서 호출. id는 App Group(SharedUserDefaults)에서 읽는다.
//

import Foundation

public struct GroupNotificationService {

    public static let shared = GroupNotificationService()

    private let baseURL = "https://wiheome.ajb.kr/api"

    private init() {}

    /// 위험(danger) 카운트 업데이트. (그룹 화면 숫자용 — 푸시는 보내지 않음)
    public func reportDangerCount(userId: String, count: Int) {
        guard !userId.isEmpty else { return }
        send(path: "/notifications/danger-count", method: "PUT",
             body: ["user_id": userId, "danger_count": count])
    }

    /// 경고(caution) 카운트 업데이트. (그룹 화면 숫자용 — 푸시는 보내지 않음)
    public func reportWarningCount(userId: String, count: Int) {
        guard !userId.isEmpty else { return }
        send(path: "/notifications/warning-count", method: "PUT",
             body: ["user_id": userId, "warning_count": count])
    }

    /// 위험 감지 시 그룹 구성원에게 실제 푸시 알림 전송.
    /// 그룹 가입 상태에서만 호출할 것(호출 측 가드). `dangerType`은 위험 유형 문자열.
    public func sendDangerAlert(fromUserId: String, dangerType: String, message: String? = nil) {
        guard !fromUserId.isEmpty else { return }
        var body: [String: Any] = ["from_user_id": fromUserId, "danger_type": dangerType]
        if let message { body["message"] = message }
        send(path: "/notifications/danger", method: "POST", body: body)
    }

    private func send(path: String, method: String, body: [String: Any]) {
        guard let url = URL(string: baseURL + path),
              let data = try? JSONSerialization.data(withJSONObject: body) else {
            print("[GroupNotify] 요청 생성 실패: \(path)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("[GroupNotify] 전송 실패 \(path): \(error.localizedDescription)")
                return
            }
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            print("[GroupNotify] \(method) \(path) → \(code)")
        }.resume()
    }
}
