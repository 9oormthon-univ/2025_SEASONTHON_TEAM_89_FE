//
//  Color+Extension.swift
//  WatchOut
//
//  Created by 어재선 on 3/5/26.
//

import SwiftUI

public extension Color {
    // Color 폴더 안
    static let main = Color("MainColor", bundle: .module)
    static let textfieldbackground = Color("textfieldbackground", bundle: .module)
    static let gray100 = Color("gray100", bundle: .module)
    static let gray200 = Color("gray200", bundle: .module)
    static let gray300 = Color("gray300", bundle: .module)
    static let gray400 = Color("gray400", bundle: .module)
    static let gray500 = Color("gray500", bundle: .module)
    static let keyboardBackground = Color("KeyboardBackground", bundle: .module)
    static let keyboardNewBackground = Color("KeyBoardNewBackgroundColor", bundle: .module)
    static let keyboardBackgroundLower = Color("keyboardbackgraound", bundle: .module)
    
    // Risk 폴더 안
    static let risk1Color1 = Color("Risk1Color1", bundle: .module)
    static let risk1Color2 = Color("Risk1Color2", bundle: .module)
    static let risk1Color3 = Color("Risk1Color3", bundle: .module)
    static let risk1Color4 = Color("Risk1Color4", bundle: .module)
    static let risk1Color5 = Color("Risk1Color5", bundle: .module)
    static let risk1Color6 = Color("Risk1Color6", bundle: .module)
    static let risk1Color7 = Color("Risk1Color7", bundle: .module)
    static let riskColor1 = Color("RiskColor1", bundle: .module)
    static let riskColor2 = Color("RiskColor2", bundle: .module)
    static let riskColor3 = Color("RiskColor3", bundle: .module)
    static let riskColor4 = Color("RiskColor4", bundle: .module)
    static let riskColor5 = Color("RiskColor5", bundle: .module)
    static let riskColor6 = Color("RiskColor6", bundle: .module)
    static let riskColor7 = Color("RiskColor7", bundle: .module)

    // 위험도 설정값(문자열 레벨)으로 색을 찾을 때 — 색 리소스가 이 모듈 번들에 있으므로 반드시 이 헬퍼를 쓸 것
    static func riskColor(_ level: String) -> Color {
        Color("RiskColor\(level)", bundle: .module)
    }

    static func risk1Color(_ level: String) -> Color {
        Color("Risk1Color\(level)", bundle: .module)
    }
}
