//
//  FraudDetectionSession.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 6/12/26.
//

import Foundation
import Combine
import Platform

/// 키보드 입력의 사기 위험도 탐지 세션.
/// WebSocketService 구독, 위험도 enum 변환, 햅틱/카운트/알림 정책을 담당한다.
/// View는 riskLevel/isConnected만 관찰하면 된다.
public final class FraudDetectionSession: ObservableObject {

    @Published public private(set) var riskLevel: RiskLevel = .safe
    @Published public private(set) var isConnected: Bool = false

    private let webSocket: WebSocketService
    private var cancellables = Set<AnyCancellable>()
    private var dangerCount = 0

    public init(webSocket: WebSocketService = .shared) {
        self.webSocket = webSocket

        webSocket.$isConnected
            .receive(on: RunLoop.main)
            .assign(to: &$isConnected)

        webSocket.$fraudResult
            .compactMap { $0?.riskLevel }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] levelString in
                self?.handle(levelString: levelString)
            }
            .store(in: &cancellables)
    }

    public func start(urlString: String) {
        riskLevel = .safe
        webSocket.connect(urlString: urlString)
    }

    public func stop() {
        webSocket.disconnect()
        riskLevel = .safe
    }

    public func check(_ text: String) {
        webSocket.checkFraudMessage(text)
    }

    private func handle(levelString: String) {
        guard let level = RiskLevel(rawValue: levelString) else { return }
        riskLevel = level

        switch level {
        case .safe:
            break

        case .caution:
            if SharedUserDefaults.isWarningHaptic {
                Haptic.notification(type: .warning)
            }
            if SharedUserDefaults.isTutorial == false {
                SharedUserDefaults.riskLevel2Count += 1
                // 서버 경고 카운트 업데이트 (그룹 화면 숫자용 — 푸시 아님)
                GroupNotificationService.shared.reportWarningCount(
                    userId: SharedUserDefaults.userID,
                    count: SharedUserDefaults.riskLevel2Count
                )
            }

        case .danger:
            dangerCount += 1
            if SharedUserDefaults.isTutorial == false {
                SharedUserDefaults.riskLevel3Count += 1
                // 서버 위험 카운트 업데이트 (그룹 화면 숫자용 — 푸시 아님)
                GroupNotificationService.shared.reportDangerCount(
                    userId: SharedUserDefaults.userID,
                    count: SharedUserDefaults.riskLevel3Count
                )
                // 그룹에 가입돼 있을 때만 그룹원에게 실제 푸시 전송
                if SharedUserDefaults.isCreateGroup {
                    GroupNotificationService.shared.sendDangerAlert(
                        fromUserId: SharedUserDefaults.userID,
                        dangerType: "금융사기"
                    )
                }
            }
            if dangerCount % 3 == 0, SharedUserDefaults.isDangerNotification {
                NotificationManager.instance.scheduleNotification(
                    title: "위험한 문장이 반복 감지되었어요",
                    subtitle: "필요하다면 즉시 신고를 도와드릴 수 있어요.",
                    secondsLater: 1
                )
            }
            if SharedUserDefaults.isDangerHaptic {
                Haptic.notification(type: .error)
            }
        }
    }
}
