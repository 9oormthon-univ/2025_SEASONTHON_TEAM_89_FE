//
//  Font+Extension.swift
//  WatchOut
//
//  Created by 어재선 on 9/3/25.
//

import SwiftUI

public enum PretendardWeight: String {
    case black = "Black"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case extraLight = "ExtraLight"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semiBold = "SemiBold"
    case thin = "Thin"
}

public extension Font {
    
    
    public static let gHeadline01: Font = .custom("GangwonEduPower", size: 32)
    
    public static let pHeadline01: Font = .custom("Pretendard-SemiBold", size: 22)
    public static let pvHeadline01: Font = .custom("PretendardVariable", size: 22)
        .weight(.bold)
    
    public static let pHeadline02: Font = .custom("Pretendard-Medium", size: 18)
    public static let pvHeadline02: Font = .custom("PretendardVariable", size: 18)
        .weight(.medium)
    
    public static let pHeadline03: Font = .custom("Pretendard-SemiBold", size: 16)
    public static let pvHeadline03: Font = .custom("PretendardVariable", size: 16)
        .weight(.semibold)
    public static let pSubtitle03: Font = .custom("Pretendard-Regular", size: 16)
    public static let pvSubtitle03: Font = .custom("PretendardVariable", size: 16)
        .weight(.regular)
    public static let pBody01: Font = .custom("Pretendard-Regular", size: 18)
    public static let pvBody01: Font = .custom("PretendardVariable", size: 18)
        .weight(.regular)
    
    public static let pBody02: Font = .custom("Pretendard-Medium", size: 16)
    public static let pvBody02: Font = .custom("PretendardVariable", size: 16)
        .weight(.regular)
    
    public static let pCaption01: Font = .custom("Pretendard-Medium", size: 14)
    public static let pvCaption01: Font = .custom("PretendardVariable", size: 14)
        .weight(.medium)
    
    public static let keyboardFont: Font = .custom("Pretendard-Regular", size: 22)
    public static let pvkeyBoardFont: Font = .custom("PretendardVariable", size: 22)
        .weight(.regular)
    
    public static func pretendard(size: CGFloat, weight: PretendardWeight) -> Font {
        return .custom("Pretendard-\(weight.rawValue)", size: size)
    }
}

