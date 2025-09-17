//
//  SettingViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 9/17/25.
//

import Foundation

class SettingViewModel: ObservableObject {
    @Published var isWarningNotification: Bool {
        didSet {
            SharedUserDefaults.isWarningNotification = isWarningNotification
            
            
        }
    }
    @Published var isDangerNotification: Bool {
        didSet {
            SharedUserDefaults.isDangerNotification = isDangerNotification
            
        }
    }
    @Published var isWarningHaptic: Bool {
        didSet {
            SharedUserDefaults.isWarningHaptic = isWarningHaptic
            
        }
    }
    @Published var isDangerHaptic: Bool {
        didSet {
            SharedUserDefaults.isDangerHaptic = isDangerHaptic
            
        }
    }
    
    @Published private var riskLevel2Color: String
    @Published private var riskLevel3Color: String
    @Published var isShowSheet: Bool = false
    @Published private var status:Status
    init(
        isWarningNotification: Bool = true,
        isDangerNotification: Bool = true,
        isWarningHaptic: Bool = true,
        isDangerHaptic: Bool = true,
        riskLevel2Color: String = "1",
        riskLevel3Color: String = "2",
        status: Status = .normal
    ) {
        self.isWarningNotification = SharedUserDefaults.isWarningNotification
        self.isDangerNotification = SharedUserDefaults.isDangerNotification
        self.isWarningHaptic = SharedUserDefaults.isWarningHaptic
        self.isDangerHaptic = SharedUserDefaults.isDangerHaptic
        self.riskLevel2Color = SharedUserDefaults.riskLevel2Color
        self.riskLevel3Color = SharedUserDefaults.riskLevel3Color
        self.status = status
    }
}

extension SettingViewModel {
    func getRiskLevelColor(level: Status) -> String {
        switch level {
        case .normal:
            return ""
        case .warning:
            return riskLevel2Color
        case .danger:
            return riskLevel3Color
        }
    }
    
    func setRiskLevelColor(level: Status, color: String) {
        switch level{
        case .normal:
            break
        case .warning:
            SharedUserDefaults.riskLevel2Color = color
            riskLevel2Color = color
        case .danger:
            SharedUserDefaults.riskLevel3Color = color
            riskLevel3Color = color
        }
    }
    
    func setStatus(status: Status) {
        switch status {
        case .normal:
            self.status = .normal
        case .warning:
            self.status = .warning
        case .danger:
            self.status = .danger
        }
    }
    
    func getStatus() -> Status {
        return self.status
    }
}
